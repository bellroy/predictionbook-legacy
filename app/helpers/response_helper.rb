# coding: utf-8
module ResponseHelper
  def confidence_for(wager)
    unless wager.confidence.blank?
      if wager.confidence == 50
        'is fence sitting'
      else
        against = wager.agree? ? "" : ' against'
        "estimated #{wager.relative_confidence}%" + against
      end
    end
  end

  def comment_for(wager)
    if wager.comment?
      if wager.action_comment?
        content_tag(:span, h(wager.action_comment), :class => "action-comment")
      else
        "said “#{content_tag(:span, markup(wager.comment), :class => "comment")}”"
      end
    end
  end
end
