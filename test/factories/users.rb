FactoryBot.define do
  factory :manager, class: "User" do
    role { "manager" }
  end

  factory :worker, class: "User" do
    role { "worker" }
  end
end
