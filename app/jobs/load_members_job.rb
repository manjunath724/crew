class LoadMembersJob < ApplicationJob
  def run
    begin
      # Fetch data from CORS endpoint using URI.open(url)
      # Parse the response as JSON
      # URL: 'https://coding-assignment.g2crowd.com'
      response = URI.open(Settings.proxy.host)
      json = JSON.load response

      unless json.nil?
        Member.transaction do
          # 'upsert_all' skips validations and callbacks
          # Hence, its usage is discouraged
          #
          # Member.upsert_all(
          #   json,
          #   unique_by: %i[ name title ],
          #   update: [:name, :title, :bio, :image_url, :updated_at]
          # )
          #
          # '.find_or_create_by(attributes)' creates records unless already persists in DB
          ids = json.map do |member|
            Member.find_or_create_by(member).id
          end

          # Deactivate 'terminated' members
          Member.deactivate_residue_by(ids)
        end
      end
    rescue => error
      # It's best to track exceptions using Airbrake and manage on Errbit.
      # Errbit: https://github.com/errbit/errbit
      # Airbrake: https://github.com/airbrake/airbrake
      puts "LoadMembersJob: #{error.message}"
    ensure
      # It's best to destroy the job in the same transaction as any other
      # changes you make. Que will mark the job as destroyed for you after the
      # run method if you don't do it yourself, but if your job writes to the DB
      # but doesn't destroy the job in the same transaction, it's possible that
      # the job could be repeated in the event of a crash.
      destroy
    end
  end
end
