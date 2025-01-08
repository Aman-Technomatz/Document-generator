class DocumentMailer < ApplicationMailer
  def send_documents(email, attach_files)
    attach_files.each do |attach|
      attachments[attach[:name]] = File.read(attach[:file].path)
    end

    mail(to: email, subject: 'Your salary slips')
  end
end
