require "zip"

class DocumentsController < ApplicationController
  # GET /documents/bundle.zip
  # Streams a ZIP archive containing every PDF in public/documents.
  def bundle
    documents_dir = Rails.public_path.join("documents")
    files = Dir.glob(documents_dir.join("*.pdf")).sort

    if files.empty?
      head :not_found
      return
    end

    buffer = Zip::OutputStream.write_buffer do |zos|
      files.each do |path|
        zos.put_next_entry(File.basename(path))
        zos.write(File.binread(path))
      end
    end
    buffer.rewind

    send_data buffer.read,
              type: "application/zip",
              filename: "Keba-Documenti.zip",
              disposition: "attachment"
  end
end
