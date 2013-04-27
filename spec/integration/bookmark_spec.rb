require_relative '../spec_helper'

describe Bookmark do
  describe 'attributes' do
    before do
      options = { 'href' => 'http://github.com', 'toread' => 'yes', 'tags' => '' }
      @bookmark = Bookmark.new(options)
    end

    it 'should respond to the correct attributes' do
      expect(@bookmark).to respond_to(:href)
      expect(@bookmark).to respond_to(:unread)
      expect(@bookmark).to respond_to(:untagged)
      expect(@bookmark).not_to respond_to(:foobar)
    end
  end

  describe 'initialize' do
    describe 'unread without tags' do
      before do
        options = { 'href' => 'http://github.com', 'toread' => 'yes', 'tags' => '' }
        @bookmark = Bookmark.new(options)
      end

      it 'have the correct attributes' do
        expect(@bookmark).not_to be_nil
        result = @bookmark.href == 'http://github.com'
        expect(result).to be_true
        expect(@bookmark.unread).to be_true
        expect(@bookmark.untagged).to be_true
      end
    end

    describe 'read with tags' do
      before do
        options = { 'href' => 'http://google.com', 'toread' => 'no', 'tags' => 'foo' }
        @bookmark = Bookmark.new(options)
      end

      it 'have the correct attributes' do
        expect(@bookmark).not_to be_nil
        result = @bookmark.href == 'http://google.com'
        expect(result).to be_true
        expect(@bookmark.unread).to be_false
        expect(@bookmark.untagged).to be_false
      end
    end
  end
end
