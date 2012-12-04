module PremailerRails
  module ActionMailerExtension 
    def self.included(base)
      base.class_eval do
        alias_method_chain :collect_responses_and_parts_order, :inline_styles
        alias_method_chain :mail, :inline_styles
      end
    end
    
    
    
    protected
    def mail_with_inline_styles(headers = {}, &block)
      mail_without_inline_styles(headers, &block)
    end

    def collect_responses_and_parts_order_with_inline_styles(headers, &block)
      responses, order = collect_responses_and_parts_order_without_inline_styles(headers, &block)
      [responses.map { |response| inline_style_response(response) }, order]
    end
    
    private
    def inline_style_response(response)
      if response[:content_type] == 'text/html'
        premailer = Premailer.new(response[:body])
        message.text_part do
          content_type "text/plain; charset=#{charset}"
          body premailer.to_plain_text
        end
        
        message.html_part do
          content_type "text/html; charset=#{charset}"
          body premailer.to_inline_css
        end
        
        response.merge :body => premailer.to_inline_css
      else
        response
      end
      
    end
    
  end
end