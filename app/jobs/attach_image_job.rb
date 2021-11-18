class AttachImageJob < ApplicationJob
  def run(member_id)
    begin
      member = Member.find(member_id)

      Member.transaction do
        # Fetch image from CORS endpoint using URI.open(url)
        avatar = URI.open(member.image_url)

        # Attach image file to an existing member
        member.image.attach(io: avatar, filename: member.name)
        member.save

        puts "Fetched info for #{member.name} - #{member.title}"
      end
    rescue => error
      # It's best to track exceptions using Airbrake and manage on Errbit.
      # Errbit: https://github.com/errbit/errbit
      # Airbrake: https://github.com/airbrake/airbrake
      puts "AttachImageJob: #{error.message}"
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
