# frozen_string_literal: true

class TodoService
  class << self
    def import(tempfile)
      file_path = Rails.root.join('tmp/import.csv')
      File.open(file_path.to_path, 'wb') { |file| file.write(tempfile.read) }

      ImportJob.perform_later(file_path.to_path)
    end
  end
end
