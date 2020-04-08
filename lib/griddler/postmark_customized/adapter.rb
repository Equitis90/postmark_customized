require 'active_support/core_ext/string/strip'

module Griddler
  module PostmarkCustomized
    class Adapter
      def initialize(params)
        @params = params
      end

      def self.normalize_params(params)
        adapter = new(params)
        adapter.normalize_params
      end

      def normalize_params
        {
          from: full_email(params[:FromFull]),
          to_email: params[:To],
          from_email: params[:From],
          to: extract_recipients(:ToFull),
          cc: extract_recipients(:CcFull),
          bcc: extract_recipients(:BccFull),
          headers: headers,
          subject: params[:Subject],
          text: params[:TextBody],
          html: params[:HtmlBody],
          original_recipient: params[:OriginalRecipient],
          reply_to: params[:ReplyTo],
          mailbox_hash: params[:MailboxHash],
          attachments: attachment_files
        }
      end

      private

      attr_reader :params

      def headers
        Array(@params[:Headers]).inject({}) do |hash, header|
          hash[header[:Name]] = header[:Value]
          hash
        end
      end

      def extract_recipients(key)
        params[key].to_a.map { |recipient| full_email(recipient) }
      end

      def full_email(contact_info)
        email = contact_info[:Email]
        if contact_info[:Name].present?
          "#{contact_info[:Name]} <#{email}>"
        else
          email
        end
      end

      def attachment_files
        attachments = Array(params[:Attachments])

        attachments.map do |attachment|
          ActionDispatch::Http::UploadedFile.new(
            filename: attachment[:Name],
            type: attachment[:ContentType],
            tempfile: create_tempfile(attachment)
          )
        end
      end

      def create_tempfile(attachment)
        filename = attachment[:Name].split('.')
        filename[0] = filename[0].gsub(/\/|\\/, '_')[0..130]
        filename[1] = ".#{filename[1]}" if filename[1]
        tempfile = Tempfile.new(filename, Dir::tmpdir, encoding: 'ascii-8bit')
        tempfile.write(content(attachment))
        tempfile.rewind
        tempfile
      end

      def content(attachment)
        if content = attachment[:Content]
          Base64.decode64(content)
        else
          content
        end
      end
    end
  end
end
