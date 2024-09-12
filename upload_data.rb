
      # Import users
        # TODO:   Move this into a front end api where the csv file can be uploaded and processed
        def import_users_from_csv(file_path = '/tmp/users.csv')
            users = []
            errors = []
            duplicate_errors = []
            index = 0
            CSV.foreach(file_path, headers: true) do |row|
                index += 1
                puts row, "================\n\n\n=========="
                puts "bitch"
                puts row.as_json, "JSON"
                if row['EMAIL'].nil? || row['USERNAME'].nil? || row['PHONE'].nil?
                    # handle error for when email is missing
                    errors << index
                    next
                end
                # find duplicated. optimize this db call.
                user = User.where(
                    'email = ? OR user_name = ? OR phone_number = ?',
                    row['EMAIL'],
                    row['USERNAME'],
                    row['PHONE']
                ).first
                if user
                    duplicate_errors << index
                    next
                end
    
                user = User.create(email: row['EMAIL'], user_name: row['USERNAME'], phone_number: row['PHONE'])
                users << user
                end
            end
            if errors.any? || duplicate_errors
                # TODO:
                # Return this data to front end and let user know which rows are missing data
                puts "WARNING: Users skipped - Missing data at indices: #{errors.join(', ')}"
                puts "WARNING: Users skipped - Duplicate data at indices: #{duplicate_errors.join(', ')}"
                return errors, duplicate_errors
            end
            []
          end
      
        # Import products
        def import_products_from_csv(file_path = '/tmp/products.csv')
            errors = []
            duplicate_errors = []
            products = []
            index = 1
            CSV.foreach(file_path, headers: true) do |row|
                if row['CODE'].nil? || row['CATEGORY'].nil? || row['NAME'].nil?
                    # handle error for when data is missing and report the exact error indices
                    errors << index
                    next
                end
                # find duplicated.
                product = Product.where(
                    'code = ?',
                    row['CODE'],
                ).first
                if product
                    duplicate_errors << index
                    next
                end
                product = Product.create(code: row['CODE'], name: row['NAME'], category: row['CATEGORY'])
                products << product
            end
            index += 1
            if errors.any? || duplicate_errors.any?
                # TODO:
                # Return this data to front end and let user know which rows are missing data
                puts "WARNING: Products skipped - Missing data at index: #{errors.join(', ')}"
                return errors
            end
            []
        end
      
          # Import order details (assuming `OrderDetail` has user_id, product_code, and order_date)
        def import_sales_records_from_csv(file_path = '/tmp/order_details.csv')
            index = 0
            errors = []
            duplicate_errors = []
            CSV.foreach(file_path, headers: true) do |row|
                index += 1
              user = User.find { |u| u.email == row['USER_EMAIL'] }
              product = Product.find { |p| p.code == row['PRODUCT_CODE'] }
      
              # Check if user and product exist before creating order detail
                if !user || !product
                    puts "WARNING: Order detail skipped - User or product not found!"
                    errors << index
                    next
                end
                order = OrderDetail.where(
                    user: user,
                    product: product
                ).first
                if order
                    puts "WARNING: Order detail skipped - Duplicate Order Details! Entry already exists"
                    duplicate_errors << index
                    next
                end
                OrderDetail.create!(user: user, product: product, order_date: row['ORDER_DATE'])
            end
            if errors.any? || d
                # TODO:
                # Return this data to front end and let user know which rows are missing data
                puts "WARNING: Order details skipped - User or product not found at index: #{errors.join(', ')}"
                return errors
            end
            []
        end
      
# Import products
import_users_from_csv()
import_products_from_csv()
import_sales_records_from_csv()