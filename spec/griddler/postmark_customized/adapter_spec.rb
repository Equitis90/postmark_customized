require 'spec_helper'

describe Griddler::PostmarkCustomized::Adapter, '.normalize_params' do
  it_should_behave_like 'Griddler adapter', :postmark_customized,
    {
      FromFull: {
        Email: 'there@example.com',
        Name: 'There',
      },
      ToFull: [{
                 Email: 'hi@example.com',
                 Name: 'Hello World',
               }],
      CcFull: [{
                 Email: 'emily@example.com',
                 Name: '',
               }],
      BccFull: [{
                  Email: 'mary@example.com',
                  Name: 'Mary',
                }],
      TextBody: 'hi',
      MailboxHash: '1234'
    }

  it 'normalizes parameters' do
    expect(Griddler::PostmarkCustomized::Adapter.normalize_params(default_params)).to be_normalized_to({
      to: ["Robert Paulson <bob@example.com>"],
      cc: ["Jack <jack@example.com>"],
      bcc: ["Mary <mary@example.com>"],
      original_recipient: "dick@example.com",
      reply_to: "john@example.com",
      from: "Tyler Durden <tdurden@example.com>",
      subject: 'Reminder: First and Second Rule',
      text: %r{Dear bob\nReply ABOVE THIS LINE\nhey sup},
      html: /<p>Dear bob<\/p>\nReply ABOVE THIS LINE\nhey sup/,
      headers: {
        "Message-ID" => "<message-id@mail.gmail.com>"
      },
      mailbox_hash: '1234'
    })
  end

  it 'handles CcFull of nil' do
    no_cc_params = default_params
    no_cc_params[:CcFull] = nil
    normalized = Griddler::PostmarkCustomized::Adapter.normalize_params(no_cc_params)

    expect(normalized[:cc]).to eq []
  end

  it 'passes the received array of files' do
    params = default_params.merge({ Attachments: [upload_1_params, upload_2_params] })

    normalized_params = Griddler::PostmarkCustomized::Adapter.normalize_params(params)

    first, second = *normalized_params[:attachments]

    expect(first.original_filename).to eq('photo1.jpg')
    expect(first.content_type).to eq(upload_1_params[:ContentType])

    expect(second.original_filename).to eq('photo2.jpg')
    expect(second.content_type).to eq(upload_2_params[:ContentType])
  end

  it 'has no attachments' do
    params = default_params

    normalized_params = Griddler::PostmarkCustomized::Adapter.normalize_params(params)

    expect(normalized_params[:attachments]).to be_empty
  end

  it 'gets rid of the original postmark params' do
    expect(Griddler::PostmarkCustomized::Adapter.normalize_params(default_params)).to be_normalized_to({
      To: nil,
      From: nil,
      ToFull: nil,
      FromFull: nil,
      CcFull: nil,
      Subject:  nil,
      TextBody: nil,
      HtmlBody: nil,
      Attachments: nil,
      MailboxHash: nil
    })
  end

  it 'can handle a blank attachment content' do
  params = default_params.merge({
      Attachments: [
        {
          Name: "empty.gif",
        }
      ]
    })
    expect {
      Griddler::PostmarkCustomized::Adapter.normalize_params(params)
    }.to_not raise_error
  end

  it 'can handle a really long name' do
    params = default_params.merge({
                                    Attachments: [
                                      {
                                        Name: ("x"*500),
                                      }
                                    ]
                                  })
    expect {
      Griddler::PostmarkCustomized::Adapter.normalize_params(params)
    }.to_not raise_error
  end

  def default_params
    {
      To: 'bob@example.com',
      From: 'tdurden@example.com',
      FromFull: {
        Email: 'tdurden@example.com',
        Name: 'Tyler Durden'
      },
      ToFull: [{
                 Email: 'bob@example.com',
                 Name: 'Robert Paulson'
               }],
      CcFull: [{
                 Email: 'jack@example.com',
                 Name: 'Jack'
               }],
      BccFull: [{
                  Email: 'mary@example.com',
                  Name: 'Mary',
                }],
      OriginalRecipient: "dick@example.com",
      ReplyTo: "john@example.com",
      Subject: 'Reminder: First and Second Rule',
      TextBody: text_body,
      HtmlBody: text_html,
      Headers: [
        {
          Name: "Message-ID",
          Value: "<message-id@mail.gmail.com>"
        }
      ],
      MailboxHash: '1234'
    }
  end

  def text_body
    <<-EOS.strip_heredoc.strip
      Dear bob
      Reply ABOVE THIS LINE
      hey sup
    EOS
  end

  def text_html
    <<-EOS.strip_heredoc.strip
      <p>Dear bob</p>
      Reply ABOVE THIS LINE
      hey sup
    EOS
  end

  def upload_1_params
    @upload_1_params ||= begin
                           file = fixture_file('photo1.jpg')
                           {
                             Name: 'photo1.jpg',
                             Content: Base64.encode64(file.read),
                             ContentType: 'image/jpeg',
                             ContentLength: file.size,
                             ContentID: "photo1.jpg@01D2DF9B.C09E7220"
                           }
                         end
  end

  def upload_2_params
    @upload_2_params ||= begin
                           file = fixture_file('photo2.jpg')
                           {
                             Name: 'photo2.jpg',
                             Content: Base64.encode64(file.read),
                             ContentType: 'image/jpeg',
                             ContentLength: file.size
                           }
                         end
  end

  def fixture_file(name)
    cwd = File.expand_path File.dirname(__FILE__)
    File.new(File.join(cwd, '..', '..', 'fixtures', name))
  end
end
