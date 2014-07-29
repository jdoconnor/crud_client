require 'spec_helper'
require 'crud_client/request'

describe CrudClient::Request do
  describe '#extract_id' do
    it 'returns the id if the first arg is not a hash' do
      request = CrudClient::Request.new(123, {foo: 'bar', bar: 'baz'})
      expect(request.id).to eq(123)
    end

    it 'returns nil if the first arg is hash' do
      request = CrudClient::Request.new({foo: 'bar', bar: 'baz'})
      expect(request.id).to be_nil
    end
  end

  describe '#options' do
    it 'returns a hash of options if supplied' do
      request = CrudClient::Request.new({foo: 'bar', bar: 'baz'})
      expect(request.options.class).to be(Hash)
      expect(request.options[:foo]).to eq('bar')
      expect(request.options[:bar]).to eq('baz')
    end

    it 'returns an empty hash if no options are supplied' do
      request = CrudClient::Request.new()
      expect(request.options.class).to be(Hash)
      expect(request.options).to eq({})
    end

    it 'returns an empty hash if only an id is supplied' do
      request = CrudClient::Request.new(123)
      expect(request.options.class).to be(Hash)
      expect(request.options).to eq({})
    end
  end
end
