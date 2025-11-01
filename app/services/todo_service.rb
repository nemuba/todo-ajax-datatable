# frozen_string_literal: true

class TodoService
  class << self
    def import(tempfile)
      File.binwrite(file_path, tempfile.read)

      ImportJob.perform_later(file_path)
    end

    def file_path
      Rails.root.join('tmp/import.csv').to_path
    end
  end
end
