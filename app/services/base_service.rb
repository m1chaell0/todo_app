class BaseService
  attr_reader :value, :error

  def self.call(*args)
    service = new(*args)
    service.call
    service
  end

  def self.call!(*args)
    service = new(*args)
    service.call!
    service
  end

  def success?
    error.blank?
  end

  def error?
    error.present?
  end

  def success!(value)
    self.value = value
  end

  def fail!(error_message = "")
    self.error = error_message.presence || "action failed"
  end

  private

  attr_writer :error, :value
end
