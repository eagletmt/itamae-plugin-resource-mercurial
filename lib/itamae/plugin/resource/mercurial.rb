require 'itamae/resource/base'

module Itamae
  module Plugin
    module Resource
      class Mercurial < Itamae::Resource::Base
        define_attribute :action, default: :create
        define_attribute :destination, type: String, default_name: true
        define_attribute :repository, type: String, required: true
        define_attribute :revision, type: String

        def action_create(options)
          ensure_hg_available

          if run_specinfra(:check_file_is_directory, attributes.destination)
            run_command(['hg', '--cwd', attributes.destination, 'pull', 'default'])
          else
            Logger.info "Cloning #{attributes.repository} into #{attributes.destination}"
            run_command(['hg', 'clone', attributes.repository, attributes.destination])
            updated!
          end

          target_revision = determine_target(attributes.revision)
          current_revision = run_command(['hg', '--cwd', attributes.destination, 'identify', '--id']).stdout.chomp

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
      end
    end
  end
end
