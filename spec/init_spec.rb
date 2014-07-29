require 'spec_helper'

describe 'Initialization' do
  it 'Overrides the values of TRACER_HEADER in the Imprint gem' do
    expect(Imprint::Tracer::TRACER_HEADER).to eq('HTTP_X_B3_TRACEID')
  end
end
