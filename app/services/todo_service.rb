# frozen_string_literal: true

class TodoService
  class << self
    def import(tempfile)
      File.open(file_path, 'wb') { |file| file.write(tempfile.read) }

      ImportJob.perform_later(file_path)
    end

    def file_path
      Rails.root.join('tmp/import.csv').to_path
    end
  end
end
