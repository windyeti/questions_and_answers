module ApplicationHelper
  def link_chooser(link)
    if link.gist?
      GistBodyService.new(link.url).body
    else
      link_to link.name, link.url, target: '_blank', class: "link link_id_#{link.id}"
    end
  end

  def can_vote_for?(resource, user)
    resource.votes.where(user_id: user.id).empty?
  end
end
