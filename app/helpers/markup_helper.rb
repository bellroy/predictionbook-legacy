# coding: utf-8
module MarkupHelper
  def show_user(user, cls=nil)
    link_to h(user), user_path(user), :class => classes('user',cls)
  end
  
  def show_time(time, cls=nil)
    content_tag(:span, time_in_words_with_context(time), :title => time.to_s, :class => classes('date',cls))
  end
  
  def show_title(text)
    sanitize textilize_without_paragraph(html_escape(text).gsub('&quot;','"')), :tags => %w(i b em strong u)
  end
  
  def confidence_and_count(prediction)
    "#{prediction.wager_count} with #{prediction.mean_confidence}%"
  end
  
  def markup(text)
    auto_link_urls(CleanCloth.new(text).to_html)
  end
  
  def classes(*args)
    args.flatten.compact.join(' ')
  end
  
  def certainty_heading(heading)
    case heading
    when "100"
      link_to "#{heading}%", 'http://en.wikipedia.org/wiki/Almost_surely', :class => 'egg', :title => 'Almost surely'
    else
      "#{heading}%"
    end
  end
  
  def outcome(prediction)
    content_tag(:span, :title => prediction.readable_outcome) do
      case prediction.outcome
      when true then '✔' 
      when false then '✘'
      else '?'
      end
    end
  end
end
