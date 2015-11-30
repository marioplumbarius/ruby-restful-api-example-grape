require_relative '../support/shared_examples/redis_shared_examples'

describe Providers::RedisProvider do
  let(:redis) { Redis.new }
  let(:logger) { Grape::API.logger }
  let(:instance) { described_class.new(logger) }

  before do
    allow(Redis).to receive(:new).and_return(redis)
  end

  describe '#get' do
    let(:key) { Faker::Lorem.word }
    let(:value) { Faker::Lorem.word }
    let(:silent) { nil }

    before do
      allow(redis).to receive(:get).with(key).and_return(value)
    end

    it 'fetches the value from redis' do
      expect(redis).to receive(:get).with(key)

      instance.get key
    end

    it 'returns the value from redis' do
      expect(instance.get key).to eq value
    end

    include_examples :cannot_connect_error, :get, Faker::Lorem.word
  end

  describe '#set' do
    let(:key) { Faker::Lorem.word }
    let(:value) { Faker::Lorem.word }
    let(:ex) { Faker::Number.digit }
    let(:silent) { nil }

    it 'sets the value in redis' do
      expect(redis).to receive(:set).with(key, value, ex: ex)

      instance.set key, value, ex, silent
    end

    include_examples :cannot_connect_error, :set, Faker::Lorem.word, Faker::Lorem.word, Faker::Number.digit
  end

  describe '#del' do
    let(:key) { Faker::Lorem.word }
    let(:silent) { nil }

    it 'deletes the value from redis' do
      expect(redis).to receive(:del).with(key)

      instance.del key
    end

    include_examples :cannot_connect_error, :del, Faker::Lorem.word
  end
end
