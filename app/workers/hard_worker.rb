class HardWorker
  include Sidekiq::Worker

  sidekiq_options unique: :until_and_while_executing

  def perform
    sleep 2

    p "Hello, world!"
    raise "BOOM!"
  end
end
