require 'itamae/resource/base'

module Itamae
  module Plugin
    module Resource
      class Mercurial < Itamae::Resource::Base
        define_attribute :action, default: :create
        define_attribute :destination, type: String, default_name: true
        define_attribute :repository, type: String, required: true
        define_attribute :revision, type: String

        def set_current_attributes
          super
          ensure_hg_available

          current.exist = run_specinfra(:check_file_is_directory, attributes.destination)
          if current.exist
            current.repository = run_command(['hg', '--cwd', attributes.destination, 'paths', 'default']).stdout.strip
            current.revision = get_current_revision
            attributes.revision = determine_target(attributes.revision)
          end
        end

        def show_differences
          super

          if current.exist
            diff = run_command(['hg', '--cwd', attributes.destination, 'diff', '--rev', current.revision, '--rev', attributes.revision]).stdout
            diff.each_line do |line|
              Logger.info line.chomp
            end
          end
        end

        def action_create(options)
          if current.exist
            run_command(['hg', '--cwd', attributes.destination, 'pull', 'default'])
          else
            Logger.info "Cloning #{attributes.repository} into #{attributes.destination}"
            run_command(['hg', 'clone', attributes.repository, attributes.destination])
            updated!
          end

          target_revision = determine_target(attributes.revision)
          current_revision = get_current_revision

          if current_revision != target_revision
            Logger.info "Updating revision from #{current_revision} to #{target_revision}"
            run_command(['hg', '--cwd', attributes.destination, 'update', '--check', target_revision])
            updated!
          end
        end

        private

        def ensure_hg_available
          if run_command('which hg', error: false).exit_status != 0
            raise '`hg` command is not available. Please install mercurial.'
          end
        end

        def determine_target(revision)
          cmd = ['hg', '--cwd', attributes.destination, 'identify']
          if revision
            cmd << '--rev' << revision
          end
          cmd << '--id' << 'default'
          run_command(cmd).stdout.chomp
        end

        def get_current_revision
          run_command(['hg', '--cwd', attributes.destination, 'identify', '--id']).stdout.chomp
        end
      end
    end
  end
end
