# frozen_string_literal: true

class ApplicationJob < ActiveJob::Base
  private

  def import_channel(message, type = 'success')
    ActionCable.server.broadcast('import_channel', message: message, type: type)
  end
end
