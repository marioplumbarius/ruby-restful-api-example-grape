describe Features::Toggle do
  subject { Class.new.extend Features::Toggle }
  let(:feature_name) { Faker::Name.first_name.downcase }

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
