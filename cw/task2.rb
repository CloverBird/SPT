class Notifier
  def initialize(deliverer)
    raise NoMethodError unless deliverer.respond_to?(:deliver)
    @deliverer = deliverer
  end

  def notify(message)
    @deliverer.deliver(message)
  end
end

class EmailAdapter
  def deliver(message)
    puts "Message was sent via email: #{message}"
  end
end

class SlackAdapter
  def deliver(message)
    puts "Message was sent via Slack: #{message}"
  end
end

email_notifier = Notifier.new(EmailAdapter.new)
email_notifier.notify("New email message")

slack_notifier = Notifier.new(SlackAdapter.new)
slack_notifier.notify("New Slack message")