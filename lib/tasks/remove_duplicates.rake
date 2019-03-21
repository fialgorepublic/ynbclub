desc "Remove Duplicates"

task remove_duplicates: :environment do
  previous_one = ''
  not_to_del = ReferralSale.where(is_approved: true)
  not_to_del_order_no = not_to_del.collect(&:order_no)
  puts "Not to del ReferralSales",not_to_del_order_no
  ReferralSale.where.not(id: not_to_del).each do |sale|
    if previous_one == sale.order_no || not_to_del_order_no.include?(sale.order_no)
      puts "Duplicate #{sale.order_no} is going to del"
      sale.delete
    else
      previous_one = sale.order_no
    end
  end
end
