# frozen_string_literal: true

RSpec.describe HasharayExt do
  it "has a version number" do
    expect(HasharayExt::VERSION).not_to be nil
  end

  it 'example.1' do
    c = {}
    expect(c.fpath("a")).to eq(nil)
    expect(c.fetch_path("a")).to eq(nil)
    expect(c.fetch_path("a", default: 42)).to eq(42)
    expect { c.fpath!("a") }.to raise_error(ArgumentError)
    expect { c.fpath!(nil) }.to raise_error(ArgumentError)
    expect { c.fpath!("#") }.to raise_error(ArgumentError)
    expect { c.fetch_path!("#") }.to raise_error(ArgumentError)
  end

  it 'example array' do
    c = [{name: "igor"}, {name: "john"}]
    expect(c.fpath("name")).to eq(["igor", "john"])

    c = [{user: {first_name: 'john'}}, {user: {first_name: "bob"}}]
    expect(c.fpath("user.first_name")).to eq(["john", "bob"])
    expect(c.fpath("user.last_name")).to eq([nil, nil])
    expect(c.fpath("user.last_name", default: 'user')).to eq(['user', 'user'])
    expect(c.fetch_path("user.last_name")).to eq([nil, nil])

    expect(c.fpath!("user.first_name")).to eq(["john", "bob"])
    expect { c.fpath!("user.last_name") }.to raise_error(ArgumentError)
    expect { c.fetch_path!("user.last_name") }.to raise_error(ArgumentError)
  end

  # dig ...
  # fetch(key, {default})

  it 'example.2' do
    c = {
      name: 'igor',
      dob: Date.today,
      projects: [
        {name: 'A', locations: ['Kyiv']},
        {name: 'B', locations: ['Paris', 'Berlin']},
      ],
      position: {
        company: {
          team: "position1",
          office: "position2",
          other: {
            status: "unknown",
            notes: ["note a", "note b"],
            summaries: [
              { "worker": "John", level: "middle" },
              { "worker": "Bob", level: "senior" },
            ]
          }
        }
      },
      "locations": [
        {
          city: 'Kyiv',
          country: 'Ukraine'
        },
        {
          city: 'Odessa',
          country: 'Ukraine'
        },
      ]
    }
    expect(c.fpath("not_exising_name")).to eq(nil)
    expect(c.fpath("not_exising_projects.not_exising_name")).to eq(nil)
    expect(c.fpath("not_exising_projects.not_exising_name", default: 42)).to eq(42)
    expect(c.fpath("name")).to eq("igor")
    expect(c.fpath("projects.name")).to eq(["A", "B"])
    expect(c.fpath("projects.locations")).to eq([["Kyiv"], ["Paris", "Berlin"]])
    expect(c.fpath!("position.company.other.summaries")).to eq([{"level"=>"middle", "worker"=>"John"}, {"level"=>"senior", "worker"=>"Bob"}])
    expect(c.fpath("position.company.other.status")).to eq("unknown")
    expect(c.fpath("position.company.team+office")).to eq({"team" => "position1", "office" => "position2"})

    # way 1
    expect(c.dig(:position, :company, :other, :summaries).map{|e| e[:worker]}).to eq(["John", "Bob"])

    # way 2 NEW WAY
    expect(c.fpath("position.company.other.summaries.worker")).to eq(["John", "Bob"])

    expect(c.fpath("position.company.other.summaries.worker+level")).to eq([["John", "middle"], ["Bob", "senior"]])
  end

  it 'example.3' do
    h = {
      "topics"=>
        {"nodes"=>
          [
            {"node"=>{"topic"=>{"name"=>"xxx"}}},
            {"node"=>{"topic"=>{"name"=>"yyy"}}}
          ]
        }
    }
    expect(h.fpath("topics.nodes.node.topic.name")).to eq(["xxx", "yyy"])
    expect(h.fpath("topics.nodes.node.topic")).to eq([{"name"=>"xxx"}, {"name"=>"yyy"}])
  end
end
