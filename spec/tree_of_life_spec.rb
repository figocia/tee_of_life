describe TreeOfLife do
  let(:tree_of_life) { TreeOfLife.new('spec/fixtures/Life On Earth') }

  describe '#in_group' do
    subject(:in_group) { tree_of_life.in_group(phylum) }

    context 'matching case' do
      let(:phylym) { 'Hexapoda' }
      specify do
        expect(in_group.first.name).to eq 'Ground beetle'
      end
    end

    context 'mismatching case' do
      let(:phylym) { 'dionycha' }
      specify do
        expect(in_group.first.name).to eq 'American jumping spider'
      end
    end

    context 'all matching' do
      let(:phylym) { 'Life on Earth' }
      specify { expect(in_group.length).to eq 7 }
    end

    context 'none matching' do
      let(:phylym) { 'Spice Girls' }
      specify { expect(in_group.length).to eq 0 }
    end

    context 'defensive coding' do
      let(:phylym) { nil }
      specify { expect(in_group.length).to eq 0 }
    end
  end

  describe '#all_that_eat' do
    subject(:all_that_eat) { tree_of_life.all_that_eat(food) }

    context 'multiple matching' do
      let(:food) { 'flies' }
      specify do
        expect(all_that_eat.length).to eq 2
        names = all_that_eat.map(&:name)
        expect(names).to include 'American Jumping Spider'
        expect(names).to include 'Dracula Ant'
      end
    end

    context 'no matching' do
      let(:food) { 'burgers' }
      specify { expect(all_that_eat.length).to eq 0 }
      end
    end

    context 'defensive coding' do
      let(:food) { nil }
      specify { expect(all_that_eat.length).to eq 0 }
    end
  end

  describe '#exercise_those_that' do
    subject(:exercise_those_that) { tree_of_life.exercise_those_that(action) }

    context 'multiple matching' do
      let(:move) { 'fly' }
      specify do
        expect(exercise_those_that).to match /Look in the sky!/
        expect(exercise_those_that).to match /The African Wattled Lapwing flies/
        expect(exercise_those_that).to match /The Graytail flies/
        expect(exercise_those_that).to match /The Josia Moth flies/
      end
    end

    context 'multiple matching' do
      let(:move) { 'scuttle' }
      specify do
        expect(exercise_those_that).to match /Look on the ground!/
        expect(exercise_those_that).to match /The American Jumping Spider scuttles/
        expect(exercise_those_that).to match /The Ground beetle scuttles/
        expect(exercise_those_that).to match /The Dracula Ant scuttles/
      end
    end

    context 'no matching' do
      let(:move) { 'skateboard' }
      specify { expect(exercise_those_that).to be_nil }
    end
  end

  describe '#describe' do
    subject(:description) { tree_of_life.describe(species) }

    context 'matching' do
      let(:species) { 'histioteuthis eltaninae' }
      specify do
        expect(description).to eq 'The Giant Squid (histioteuthis eltaninae) ' \
                                  'eats plankton, and swims'
      end
    end
  end
end
