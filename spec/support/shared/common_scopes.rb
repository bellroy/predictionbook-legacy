# coding: utf-8
#expects described_type defined on the including example group
shared_examples_for 'model class with common scopes' do
  include ModelFactory
  
  describe '“limit“ scope' do
    before(:each) do
      5.times{create_described_type}
    end
    it 'should default to 3' do
      described_type.limit.length.should == 3
    end
    
    it 'should take argument' do
      described_type.limit(4).length.should == 4
    end
  end
end
