# https://gist.github.com/mordonez/7091924
require 'trello'
include Trello

Trello.configure do |config|
  config.developer_public_key = ENV['TRELLO_DEVELOPER_PUBLIC_KEY']
  config.member_token = ENV['TRELLO_MEMBER_TOKEN']
end

boards = {
  "my-trello-board" => ENV['TRELLO_BOARD_ID'],
}

class MyTrello
  def initialize(widget_id, board_id)
    @widget_id = widget_id
    @board_id = board_id
  end

  def widget_id()
    @widget_id
  end

  def board_id()
    @board_id
  end

  def status_list()
    status = Array.new
    Board.find(@board_id).lists.each do |list|
      status.push({label: list.id, value: list.cards.map{|card| card.id }})
    end
    status
  end

  def card_list(list_id)
    cards = Array.new
    List.find(list_id).cards.each do |card|
      responsible = card.member_ids.map do |member_id|
        Member.find(member_id).initials
      end
      cards.push({
        label: card.name,
        value: responsible.first(3).join(','),
      })
    end
    cards
  end
end

@MyTrello = []
boards.each do |widget_id, board_id|
  begin
    @MyTrello.push(MyTrello.new(widget_id, board_id))
  rescue Exception => e
    puts e.to_s
  end
end

SCHEDULER.every '1m', :first_in => 0 do |job|
  @MyTrello.each do |board|
    status = board.card_list(ENV['TRELLO_LIST_ID'])

    send_event(board.widget_id, { items: status })
  end
end
