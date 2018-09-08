require 'spec_helper'

RSpec.describe Nmax::LimitBuffer do
  let(:limit) { 2 }
  let(:buffer) { described_class.new(limit) }
  subject { buffer.result }

  it { expect(subject).to eq [] }

  context 'when sort' do
    before { buffer.merge! [2, 3] }
    it { expect(subject).to eq [3, 2] }
  end

  context 'when more limit' do
    before { buffer.merge! [3, 2, 1] }
    it { expect(subject).to eq [3, 2] }

    context 'when cut to limit' do
      before { buffer.merge! [4] }
      it { expect(subject).to eq [4, 3] }

      context 'when uniq values' do
        before { buffer.merge! [3, 3, 4] }
        it { expect(subject).to eq [4, 3] }
      end
    end
  end

  context 'when not set limit' do
    let(:buffer) { described_class.new }
    before { buffer.merge! [2, 3] }

    context 'when not cut' do
      before { buffer.merge! [1] }
      it { expect(subject).to eq [3, 2, 1] }
    end
  end
end
