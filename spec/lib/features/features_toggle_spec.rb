describe Features::Toggle do
  subject { Class.new.extend Features::Toggle }
  let(:feature_name) { "mario" }

  describe '.enabled?' do
    context 'when it is enabled' do
      xit 'returns true' do

      end
    end

    context 'when it is not enabled' do
      xit 'returns false' do
      end
    end
  end
end
