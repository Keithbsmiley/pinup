require_relative '../spec_helper'

describe Pinup::Queries do
  describe 'list_items' do
    before do
      @items = Pinup::Queries.list_items
    end

    it 'shoud return some number of items' do
      result = @items.count > 0
      expect(result).to be_true
    end
  end

  describe 'filter_items' do
    describe 'read/unread items' do
      describe 'unread items' do
        before do
          items     = Pinup::Queries.list_items
          @filtered = Pinup::Queries.filter_items(items, true, false, 20)
        end

        it 'should return only unread items' do
          @filtered.each do |item|
            expect(item.unread).to be_true
          end
        end
      end

      describe 'read items' do
        before do
          items = Pinup::Queries.list_items
          @filtered = Pinup::Queries.filter_items(items, false, false, 20)
        end

        it 'should return only read items' do
          @filtered.each do |item|
            expect(item.unread).to be_false
          end
        end
      end
    end

    describe 'untagged/tagged items' do
      describe 'untagged items' do
        before do
          items     = Pinup::Queries.list_items
          @filtered = Pinup::Queries.filter_items(items, false, true, 20)
        end

        it 'should return only untagged items' do
          @filtered.each do |item|
            expect(item.untagged).to be_true
          end
        end
      end

      describe 'tagged items' do
        before do
          items     = Pinup::Queries.list_items
          @filtered = Pinup::Queries.filter_items(items, false, false, 20)
        end

        it 'should return only untagged items' do
          result = @filtered.count > 0
          expect(result).to be_true
          @filtered.each do |item|
            expect(item.untagged).to be_false
          end
        end
      end
    end
  end

  describe 'item_string' do
    before do
      @item     = Bookmark.new({ "href" => "http://google.com" })
      @item2    = Bookmark.new({ "href" => "http://github.com" })
      @urls     = [ @item, @item2 ]
      @response = Pinup::Queries.item_string(@urls)
      @string   = "http://google.com\nhttp://github.com\n"
    end

    it 'should return a correctly formatted string' do
      result = @response == @string
      expect(result).to be_true
    end
  end
end
