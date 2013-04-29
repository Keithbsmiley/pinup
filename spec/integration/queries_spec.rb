require_relative '../spec_helper'

describe Pinup::Queries do
  describe 'list_items' do
    before do
      items  = Pinup::Queries.list_items
      @posts = JSON.parse(items)
    end

    it 'should return some number of items' do
      result = @posts.count > 0
      expect(result).to be_true
    end

    describe 'token issues' do
      before(:each) do
        @path = File.expand_path('~/foobar') 
        Pinup::Settings.write_settings({ path: @path })
      end

      after(:each) do
        File.delete(@path) if File.exists?(@path)
        Pinup::Settings.clear_settings
      end

      describe 'no token' do
        it 'should return nil' do
          expect(Pinup::Queries.list_items).to be_nil
        end
      end

      describe 'invalid token' do
        before do
          Pinup::Settings.save_token({ token: 'foo:bar', path: @path })
        end

        it 'should return nil' do
          expect(Pinup::Queries.list_items).to be_nil
        end
      end
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
            expect(item.untagged).to be_false
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
            expect(item.untagged).to be_false
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
            expect(item.unread).to be_false
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
            expect(item.unread).to be_false
            expect(item.untagged).to be_false
          end
        end
      end
    end

    # Note these will only work if the default pinboard account unread & untagged items
    describe 'number of items' do
      describe 'an invalid number' do
        describe 'zero items' do
          before do
            items = Pinup::Queries.list_items
            @filtered = Pinup::Queries.filter_items(items, false, false, 0)
          end

          it 'should return the default number of items' do
            expect(@filtered.count).to equal(20)
          end
        end

        describe 'negative items' do
          before do
            items = Pinup::Queries.list_items
            @filtered = Pinup::Queries.filter_items(items, false, false, -9)
          end

          it 'should return the default number of items' do
            expect(@filtered.count).to equal(20)
          end
        end
      end

      describe 'some number of unread items' do
        before do
          items = Pinup::Queries.list_items
          @filtered = Pinup::Queries.filter_items(items, false, false, 14)
        end

        it 'should return the correct number of items' do
          expect(@filtered.count).to equal(14)
        end
      end
    end

    describe 'improper JSON' do
      it 'should exit' do
        begin
          Pinup::Queries.filter_items('foobar', true, true, 10)
        rescue SystemExit => e
          expect(e).not_to be_nil
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
