require 'spec_helper'
require 'crud_client/crud_client'

class PapaFake
end
class PapaFake::FakeService < CrudClient::CrudClient
end

module Imprint
  class Tracer
    def self.get_trace_id
      'some-trace-id'
    end
  end
end

describe CrudClient::CrudClient do
  ENV['PAPA_FAKE_URL'] = "http://localhost:9292"
  ENV['SERVICE_NAME'] = "fake-service"
  context 'when making class level requests' do
    it 'performs a get' do
      PapaFake::FakeService.should_receive(:issue_request){ |method, url, options|
        expect(method).to eq(:get)
        expect(url).to eq("http://localhost:9292/fake_services/1")
      }.and_return('{}')
      PapaFake::FakeService.get("1")
    end

    it 'performs a show (get)' do
      PapaFake::FakeService.should_receive(:issue_request){ |method, url, options|
        expect(method).to eq(:get)
        expect(url).to eq("http://localhost:9292/fake_services/1")
      }.and_return('{}')
      PapaFake::FakeService.show("1")
    end

    it 'performs an arbitrary call' do
      PapaFake::FakeService.should_receive(:issue_request){ |method, url, options|
        expect(method).to eq(:get)
        expect(url).to eq("http://localhost:9292/fake_services/cookie")
      }.and_return('{}')
      PapaFake::FakeService.get("cookie")
    end

    context 'when the get request contains a hash' do
      it 'performs an index' do
        PapaFake::FakeService.should_receive(:issue_request){ |method, url, options|
          expect(method).to eq(:get)
          expect(url).to eq("http://localhost:9292/fake_services/")
          expect(options).to eq({ foo: 'bar' })
        }.and_return('{}')
        PapaFake::FakeService.get(foo: 'bar')
      end
    end

    context 'when the get request contains nothing' do
      it 'performs an index' do
        PapaFake::FakeService.should_receive(:issue_request){ |method, url, options|
          expect(method).to eq(:get)
          expect(url).to eq("http://localhost:9292/fake_services/")
          expect(options).to eq({})
        }.and_return('{}')
        PapaFake::FakeService.get
      end
    end

    it 'performs a post' do
      PapaFake::FakeService.should_receive(:issue_request){ |method, url, options|
        expect(method).to eq(:post)
        expect(url).to eq("http://localhost:9292/fake_services/")
        expect(options).to eq({ foo: 'bar' })
      }.and_return('{}')
      PapaFake::FakeService.post(foo: 'bar')
    end

    it 'performs a put' do
      PapaFake::FakeService.should_receive(:issue_request){ |method, url, options|
        expect(method).to eq(:put)
        expect(url).to eq("http://localhost:9292/fake_services/1")
        expect(options).to eq({ foo: 'bar' })
      }.and_return('{}')
      PapaFake::FakeService.put("1", foo: 'bar')
    end

    it 'performs a delete' do
      PapaFake::FakeService.should_receive(:issue_request){ |method, url, options|
        expect(method).to eq(:delete)
        expect(url).to eq("http://localhost:9292/fake_services/1")
        expect(options).to eq({ foo: 'bar' })
      }.and_return('{}')
      PapaFake::FakeService.delete("1", foo: 'bar')
    end

    it 'adds a tracer bullet to the request' do
      PapaFake::FakeService.issue_request(:get, '/', {})
      expect(PapaFake::FakeService.headers['X_B3_TRACEID'].empty?).to_not be true
    end

    it 'adds a User-Agent header to the request' do
      PapaFake::FakeService.issue_request(:get, '/', {})
      expect(PapaFake::FakeService.headers['User-Agent']).to include(ENV['SERVICE_NAME'])
      expect(PapaFake::FakeService.headers['User-Agent']).to match(/\/.+\z/)
    end
  end
end
