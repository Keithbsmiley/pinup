require_relative '../spec_helper'

describe Pinup::Queries do
  describe 'list_items' do
    describe 'read/unread items' do
      describe 'unread items' do
        before do
          items     = Pinup::Queries.list_items
          @filtered = Pinup::Queries.filter_items(items, true, false)
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
          @filtered = Pinup::Queries.filter_items(items, false, false)
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
          @filtered = Pinup::Queries.filter_items(items, false, true)
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
          @filtered = Pinup::Queries.filter_items(items, false, false)
        end

        it 'should return only untagged items' do
          @filtered.each do |item|
            expect(item.untagged).to be_false
          end
        end
      end
    end

    describe 'number of items' do
      describe 'an indescript number of items' do
        before do
          json   = JSON.parse(Pinup::Queries.list_items)
          @items = json['posts']
        end

        it 'should return some number of items (my current default is 20)' do
          result = @items.count > 0
          expect(result).to be_true
          expect(@items.count).to equal(20)
        end
      end

      describe 'zero items' do
        before do
          json   = JSON.parse(Pinup::Queries.list_items(0))
          @items = json['posts']
        end

        it 'should return the default number of items' do
          result = @items.count > 0
          expect(result).to be_true
          expect(@items.count).to equal(15)
        end
      end

      describe 'some number of items' do
        before do
          json   = JSON.parse(Pinup::Queries.list_items(33))
          @items = json['posts']
        end

        it 'should return zero items' do
          expect(@items.count).to equal(33)
        end
      end

      describe 'over the maximum (currently 100) items' do
        before do
          json   = JSON.parse(Pinup::Queries.list_items(138))
          @items = json['posts']
        end

        it 'should return the maximum amount of items' do
          expect(@items.count).to equal(100)
        end
      end
    end
  end
end
