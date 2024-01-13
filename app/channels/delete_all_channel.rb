# frozen_string_literal: true

class DeleteAllChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'delete_all_channel'
  end
end
