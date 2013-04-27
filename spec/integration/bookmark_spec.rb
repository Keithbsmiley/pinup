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

  describe 'is_unread' do
    it 'should return true only when toread is "yes"' do
      expect(Bookmark.is_unread('yes')).to be_true
    end

    it 'should return false otherwise' do
      expect(Bookmark.is_unread('false')).to be_false
      expect(Bookmark.is_unread('no')).to be_false
      expect(Bookmark.is_unread('foo')).to be_false
    end
  end


  describe 'is_untagged' do
    it 'should return true if there is nothing in the tag field' do
      expect(Bookmark.is_untagged('   ')).to be_true
      expect(Bookmark.is_untagged("\n \t \r")).to be_true
    end

    it 'should return false if there is something in the tag field' do
      expect(Bookmark.is_untagged('foo')).to be_false
      expect(Bookmark.is_untagged('foo bar')).to be_false
    end
  end

  describe 'to_s' do
    before do
      options = { 'href' => 'http://google.com', 'toread' => 'no', 'tags' => 'foo' }
      @bookmark = Bookmark.new(options)
      @response = @bookmark.to_s
    end

    it 'should contain the URL' do
      result = @response.include? 'google.com'
      expect(result).to be_true
    end

    it 'should contain unread settings' do
      result = @response.include? 'Unread: false'
      expect(result).to be_true
    end

    it 'should contain the URL' do
      result = @response.include? 'Untagged: false'
      expect(result).to be_true
    end
  end
end
