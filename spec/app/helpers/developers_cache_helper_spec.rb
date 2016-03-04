describe DevelopersCacheHelper do
  subject { Class.new.extend DevelopersCacheHelper }
  let(:cache_key) { APP_CONFIG['helpers']['developers_helper']['cache_key_prefix'] }
  let(:cache_expiration) { APP_CONFIG['helpers']['developers_helper']['cache_expiration'] }

  describe '.cache_key_prefix' do
    it 'returns the default cache key for developers' do
      expect(subject.cache_key_prefix).to eq cache_key
    end
  end

  describe '.cache_expiration' do
    it 'returns the default expiration for developers' do
      expect(subject.cache_expiration).to eq cache_expiration
    end
  end
end
