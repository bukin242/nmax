require 'spec_helper'

RSpec.describe Nmax::CLI do
  let(:argv) { [1] }
  subject { described_class.call(argv) }

  before do
    allow(Process).to receive(:exit).and_return(nil)
    allow(STDERR).to receive(:puts).and_return('error')
    allow_any_instance_of(described_class).to receive(:process).and_return(true)
  end

  it { expect { subject }.not_to output.to_stderr_from_any_process }

  context 'when empty arguments' do
    let(:argv) { [] }
    it { expect { subject }.to output.to_stderr_from_any_process }
  end

  context 'when argument not number' do
    let(:argv) { ['a'] }
    it { expect { subject }.to output.to_stderr_from_any_process }
  end
end
