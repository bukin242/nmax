require 'spec_helper'

RSpec.describe Nmax::Finder do
  let(:limit) { 10 }
  let(:file_string) { '' }
  let(:stdin) { StringIO.new file_string }

  context '.numbers_list' do
    subject { described_class.numbers_list(limit, stdin) }
    it { expect(subject).to be_empty }

    context 'when reverse sort numbers' do
      let(:file_string) { '11 555 222 4444' }
      it { expect(subject).to eq [4444, 555, 222, 11] }
    end

    context 'when limit numbers' do
      let(:limit) { 5 }
      let(:file_string) { '11 22 33 44 55 66 77 88 99' }
      it { expect(subject).to eq [99, 88, 77, 66, 55] }

      context 'limit zero' do
        let(:limit) { 0 }
        it { expect(subject).to be_empty }
      end

      context 'limit less than zero' do
        let(:limit) { -1 }
        it { expect(subject).to be_empty }
      end
    end

    context 'when between numbers' do
      context 'when one symbol number' do
        let(:file_string) { '33 2 11' }
        it { expect(subject).to eq [33, 11] }
      end

      context 'when text' do
        let(:file_string) { '22AlphaBet11' }
        it { expect(subject).to eq [22, 11] }
      end

      context 'when newline symbol' do
        let(:file_string) { "33\n22\r\n11" }
        it { expect(subject).to eq [33, 22, 11] }
      end
    end

    context 'when between block' do
      let(:file_string) { '4444Alp3333ha2222Bet1111' }
      before { stub_const('Nmax::Configuration::READ_BLOCK_SIZE', 4) }
      it { expect(subject).to eq [4444, 3333, 2222, 1111] }

      context 'when continuous sequence numbers' do
        let(:file_string) { '1234567890' }
        it { expect(subject).to eq [1234567890] }
      end
    end
  end
end
