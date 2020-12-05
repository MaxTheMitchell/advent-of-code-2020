require_relative "./main"

describe "tests" do
  it "finds_row" do
    expect(find_row("FBFBBFFRLR")).to eq(44)
    expect(find_row("BFFFBBFRRR")).to eq(70)
    expect(find_row("FFFBBBFRRR")).to eq(14)
    expect(find_row("BBFFBBFRLL")).to eq(102)
  end

  it "finds_col" do
    expect(find_col("FBFBBFFRLR"[/[LR]+/])).to eq(5)
    expect(find_col("BFFFBBFRRR"[/[LR]+/])).to eq(7)
    expect(find_col("FFFBBBFRRR"[/[LR]+/])).to eq(7)
    expect(find_col("BBFFBBFRLL"[/[LR]+/])).to eq(4)
  end

  it "should have all uniq ids" do
    expect(get_all_ids.length).to eq(get_all_ids.uniq.length)
  end
end
