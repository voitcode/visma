module Visma
  # Visma Global customers table
  class Customer < Visma::Base
    self.table_name += 'Customer'
    self.primary_key = 'CustomerNo'
    include Visma::Timestamp
    include Visma::CreatedScopes
    include Visma::ChangeBy
    include Visma::PrimaryKey

    enum InActiveYesNo: %i[active inactive]
    enum ChainLeaderYesNo: %i[not_chain_leader chain_leader]

    # Duplicating methods to work with best_in_place field for :active
    def active
      active?
    end

    def active=(val)
      val = val.class == String ? val.casecmp('true').zero? : val
      self.InActiveYesNo = val ? 0 : 1
    end

    belongs_to :employee, foreign_key: :EmployeeNo

    has_many :customer_order, foreign_key: :CustomerNo
    alias orders customer_order
    has_many :customer_order_copy, foreign_key: :CustomerNo
    alias processed_orders customer_order_copy

    # Customers with factoring enabled
    scope :with_factoring_enabled, lambda {
      where(CustomerProfileNo: VISMA_CONFIG['factoring_customer_profile_number'])
        .where(FormProfileCustNo: VISMA_CONFIG['factoring_form_profile_number'])
        .where(RemittanceProfileNo: VISMA_CONFIG['factoring_remittance_profile_number'])
        .where('FactCustomerNo = CustomerNo')
    }
    scope :with_factoring_disabled, lambda {
      where.not(CustomerNo: with_factoring_enabled.pluck(:CustomerNo))
    }

    # Customers with activity in sales since given date
    scope :with_sales_since, lambda { |since_date|
      joins(:customer_order_copy)
        .where('CustomerOrderCopy.Created > ?', since_date)
        .uniq
    }
    scope :with_no_sales_since, lambda { |since_date|
      sales_since = with_sales_since(since_date)
                    .pluck(:CustomerNo)
                    .uniq
      where.not(CustomerNo: sales_since)
    }

    has_many :chain_order,
             foreign_key: :ChainNo,
             class_name: 'Visma::CustomerOrderCopy'
    has_many :chain_order_copy,
             foreign_key: :ChainNo,
             class_name: 'Visma::CustomerOrderCopy'

    # Customers with activity in chain sales since given date
    scope :with_chain_sales_since, lambda { |since_date|
      joins(:chain_order_copy)
        .where('CustomerOrderCopy.Created > ?', since_date)
        .uniq
    }
    scope :with_no_chain_sales_since, lambda { |since_date|
      sales_since = with_chain_sales_since(since_date)
                    .pluck(:ChainNo)
                    .uniq
      where.not(ChainNo: sales_since)
    }

    scope :missing_employee, -> { where(employeeno: 0) }
    scope :missing_branch, -> { where(BusinessNo: 0) }
    scope :missing_post_code, -> { where(PostCode: [nil, '']) }

    has_many :transactions,
             foreign_key: :CustomerNo,
             class_name: 'Visma::GLAccountTransaction'
    has_many :edi_transactions,
             foreign_key: 'PartyID',
             class_name: 'Visma::EdiTransaction'

    has_one :primary_delivery_address,
            foreign_key: :DeliveryAddressNo,
            primary_key: :DeliveryAddressNo,
            class_name: 'Visma::CustomerDeliveryAddress'
    accepts_nested_attributes_for :primary_delivery_address
    has_many :delivery_addresses,
             foreign_key: :CustomerNo,
             class_name: 'Visma::CustomerDeliveryAddress'

    has_one :primary_invoice_address,
            foreign_key: :InvoiceAdressNo,
            primary_key: :InvoiceAdressNo,
            class_name: 'Visma::CustomerInvoiceAddress'
    accepts_nested_attributes_for :primary_invoice_address
    has_many :invoice_addresses,
             foreign_key: :InvoiceAdressCustomerNo,
             class_name: 'Visma::CustomerInvoiceAddress'

    has_many :contacts, foreign_key: :CustomerNo
    has_one :invoice_contact,
            foreign_key: :ContactNo,
            primary_key: :ContactNoInvoice,
            class_name: 'Visma::Contact'
    has_one :delivery_contact,
            foreign_key: :ContactNo,
            primary_key: :ContactNoDelivery,
            class_name: 'Visma::Contact'

    belongs_to :chain,
               foreign_key: :ChainNo,
               class_name: 'Visma::Customer'
    has_many :chain_members,
             foreign_key: :ChainNo,
             class_name: 'Visma::Customer'

    # Price list, discount group and such
    belongs_to :price_list, foreign_key: 'PriceListNo'
    belongs_to :discount_group_customer, foreign_key: 'DiscountGrpCustNo'
    alias discount_group discount_group_customer
    has_many :discount_agreement_customer,
             -> (cu) { unscope(:where).for_customer(cu) }
    alias discount_agreements discount_agreement_customer

    belongs_to :customer_bonus_profile, foreign_key: :CustomerBonusProfileNo

    # TODO: figure out campaigns in Visma Global, this is wrong
    # has_many :campaign_price_list, foreign_key: "CustomerNo"
    #  has_many :chain_campaign_price_list, foreign_key: "ChainNo", class_name: 'Visma::CampaignPriceList'

    has_one :customer_sum, foreign_key: 'CustomerNo'

    # Isonor - Isomat custom table relationships
    has_many :z_usr_ruter_pr_kunde, foreign_key: 'ZUsrCustomerNo'
    has_many :z_usr_ruter, through: :z_usr_ruter_pr_kunde

    # Form profile: Which papers to use
    belongs_to :form_profile_customer, foreign_key: :FormProfileCustNo
    # Print profile: How to send papers
    belongs_to :print_profile, foreign_key: :PrintProfileNo
    # EDI profile: How to electronically send order data
    belongs_to :customer_edi_profile, foreign_key: :EdiProfileNo
    # Customer profile: How to handle the customer financially
    belongs_to :customer_profile, foreign_key: :CustomerProfileNo

    # Remittance profile
    belongs_to :remittance_profile, foreign_key: :RemittanceProfileNo

    after_initialize :set_default_values
    before_validation :set_sort_name
    validates :CustomerNo, :Name, :WareHouseNo, :FixedAddnDedNo,
              :TermsOfDeliveryNo, :DeliveryMethodsNo, :BuContactNo, :BusinessNo,
              :ChainNo, :EmployeeNo, :CustomerGrpNo, :DistrictNo,
              :LastMovementDate, :GrossInvoicingYesNo,
              :LockedYesNo, :OurSupplNo, :CustomerTypeNo,
              :InActiveYesNo, :ContactNoDelivery, :AccessLevel, :SortName,
              :ChainLeaderYesNo, :TypeOfChain, :ProductNo, :ProjectNo, :DepNo,
              :SupplierNo, :RoundingCode, :ExtraCostUnitIVNo,
              :ExtraCostUnitIIINo, :ExtraCostUnitIINo, :ExtraCostUnitINo,
              :CustomerBonusProfileNo, :LocalGovernmentNo, :ChartererCompanyNo,
              :AgentNo, :CommissionProfileNo, :LastSubscriptionInvoiceDate,
              :SubscriptionProfileNo, :NoOfSubscription, :AgentYesNo,
              :EbusinessType, :ShipmentTypeNo, :AcceptReplacementArticleYesNo,
              :NotBreakageYesNo, :AverageCreditPeriod, :PaymentPattern,
              :UpperAmountAltPriceList, :AltPriceListYesNo, :AltPriceListNo,
              :MergeToCustomerNo, :ContactNoListOfContents, :ContactNoReminder,
              :AgreementGiroType, :EdiProfileNo, :EinvoiceStatus,
              :AgreementOrderCusGrpNo, :ChainPriceTypeHasPriorityYesNo,
              :ZpiderImportProfileNo, :EdiTestYesNo, :EDITestMode,
              :CreditControlLastActionTime, :ElectronicInvoiceActive,
              :ElectronicInvoiceByMailYesNo, :CustProfilesOverrideChainProfiles,
              :ZUsrEDIProfile, :SwiftCodeNo, :ContactsUpdatedInBizWeb,
              :DateUpdatedContactData, :DateUpdatedFinancialData,
              :FinancialDataUpdatedInBizWeb, :MaindataUpdatedInBizWeb,
              :LastUpdatedInBizWeb, :LastupdatedFromBizWeb,
              :DateLastFinancialStatement, :AnnualSales, :Result, :NoOfEmployees,
              :CreditBlockAllowOfferAndNewOrders, :ContactNoConfirmOrder,
              :ContactNoPickingList, :MDM_Deleted, :MDM_Version,
              :MDM_SyncVersion, :ZUsrVisPaaWeb, :FormProfileCustNo,
              :CustomerProfileNo, :TermsOfPayCustNo, :PriceCode, :CurrencyNo,
              :GLAccountRec, :CountryNo, :RegistrationDate,
              :DebtCollectionGrpNo, :UtilityBits, :RemittanceProfileNo,
              :RemainderOrderYesNo, :PrintProfileNo,
              :BusinessNo, :CustomerGrpNo, :EmailAddress,
              presence: true

    # Is this Customer enabled with factoring
    def factoring_enabled
      [
        self.CustomerProfileNo == VISMA_CONFIG['factoring_customer_profile_number'],
        self.FormProfileCustNo == VISMA_CONFIG['factoring_form_profile_number'],
        self.RemittanceProfileNo == VISMA_CONFIG['factoring_remittance_profile_number'],
        self.CustomerNo == self.FactCustomerNo.to_i
      ].all?
    end

    # Return factoring status
    def factoring
      factoring_enabled ? :enabled : :disabled
    end

    # true/false enable or disable factoring
    def factoring=(val)
      return enable_factoring if val
      disable_factoring
    end

    # Enable factoring, by setting profiles and factoring customer number
    def enable_factoring
      self.CustomerProfileNo = VISMA_CONFIG['factoring_customer_profile_number']
      self.FormProfileCustNo = VISMA_CONFIG['factoring_form_profile_number']
      self.RemittanceProfileNo = VISMA_CONFIG['factoring_remittance_profile_number']
      self.FactCustomerNo = self.CustomerNo.to_s
    end

    # Disable factoring, by setting profiles to default (1) and removing
    # factoring customer number
    def disable_factoring
      self.CustomerProfileNo = 1
      self.FormProfileCustNo = 1
      self.RemittanceProfileNo = 1
      self.FactCustomerNo = nil
    end

    # Return an array of the current prices available for a given article
    def prices_for(artno, at = Date.today)
      discounts_for(artno, at).sort_by(&:price)
    end

    # Return the correct price for a given article at a given date
    def price_for(artno, at = Date.today)
      discounts_for(artno, at).min_by(&:price).price
    rescue NoMethodError
      nil
    end

    # Return the correct price, explained
    def explained_price_for(artno)
      prices_for(artno.to_i).first.explained_price
    end

    # Find all discount agreements for given article number at a given date
    def discounts_for(artno, at_date = Date.today)
      discounts = discount_agreements.at(at_date).for(artno)
      discounts += chain.discount_agreements.at(at_date).for(artno) if chain_member?
      discounts.uniq.sort_by(&:price)
    end

    # The attributes to use for looking up DiscountAgreementCustomer
    def discount_sources
      s = ['CustomerNo']
      s << 'PriceListNo' if list?
      s << 'DiscountGrpCustNo' if group?
      s
    end

    # The discount sources SQL query string
    def discount_sources_sql_str
      "#{discount_sources.join(' = ? OR ')} = ?"
    end

    # The values to use for looking up DiscountAgreementCustomer
    def discount_ids
      discount_sources.map { |att| send(att) }
    end

    # Member of a DiscountGroupCustomer?
    def group?
      !self.DiscountGrpCustNo.zero?
    end

    # Member of a PriceList?
    def list?
      !self.PriceListNo.zero?
    end

    # Member of a chain?
    def chain_member?
      not_chain_leader? and not self.ChainNo.zero?
    end

    # The current invoice address.
    # Based on wether the Chain or the Customer is getting the bill
    def current_invoice_address
      return invoice_address if chain.blank?
      return chain.invoice_address if self.TypeOfChain == 1
      invoice_address
    end

    def address
      [self.Address1, self.Address2, "#{self.PostCode} #{self.PostOffice}"].join(', ')
    end

    def active_list
      where ['LastUpdate > ?', Date.new(Time.now.year - 1)]
    end

    def cleanphone(c)
      number, cell = c.Telephone.split('/')
      c.Telephone = phoneme(number)
      cphn = begin
               phoneme(cell)
             rescue
               nil
             end
      if c.ZUsrMobilNr.blank?
        c.ZUsrMobilNr = cphn
      else
        c.Password = cphn
      end

      c
    end

    # Clean up phone number string
    def phoneme(number)
      number.gsub(/-+|\s+/, '').gsub(/(\d{2,2})(\d{2,2})(\d{2,2})(\d{2,2})/, '\\1 \\2 \\3 \\4')
    end

    # When was the last invoice sent?
    def last_invoiced
      processed_orders.last.try(:Created)
    end

    # Exclude some info from json output.
    def to_json(options = {})
      options[:except] ||= [:UtilityBits]
      as_json(options).merge('factoring_enabled' => factoring_enabled)
    end

    class << self
      # Find ICA stores by postcode
      def ica(postcode)
        where(PostCode: postcode.to_s).where("Name like '%rimi%' or Name like '%matkrok%' or Name like '%ica%'").all
      end

      def all_with_discount_agreements
        find(Visma::DiscountAgreementCustomer.uniq_ids(:CustomerNo))
      end

      # Exclude some info from json output.
      def to_json(options = {})
        options[:except] ||= [:UtilityBits]
        super(options)
      end
    end

    # Default values for a new Visma::Customer record
    #
    # A lot of fields are zero by default in Visma Global
    # Many date/time fields are unix epoch
    #
    # Then there are the actual default valules.
    # We have not looked it up in the database, so this is specific for the
    # customer me were working on at the time.
    def self.defaults
      zeroes = %w[
        Balance WareHouseNo FixedAddnDedNo TermsOfDeliveryNo DeliveryMethodsNo
        BuContactNo BusinessNo ChainNo EmployeeNo CustomerGrpNo DistrictNo
        ContactNoInvoice GrossInvoicingYesNo DiscountGrpCustNo LockedYesNo
        OurSupplNo CustomerTypeNo InActiveYesNo ContactNoDelivery AccessLevel
        ChainLeaderYesNo TypeOfChain ProductNo ProjectNo DepNo SupplierNo
        RoundingCode PriceListNo ExtraCostUnitIVNo ExtraCostUnitIIINo
        ExtraCostUnitIINo ExtraCostUnitINo CustomerBonusProfileNo
        LocalGovernmentNo ChartererCompanyNo AgentNo CommissionProfileNo
        SubscriptionProfileNo NoOfSubscription AgentYesNo EbusinessType
        ShipmentTypeNo AcceptReplacementArticleYesNo NotBreakageYesNo
        AverageCreditPeriod PaymentPattern UpperAmountAltPriceList
        AltPriceListYesNo AltPriceListNo MergeToCustomerNo
        ContactNoListOfContents ContactNoReminder AgreementGiroType EdiProfileNo
        EinvoiceStatus AgreementOrderCusGrpNo ChainPriceTypeHasPriorityYesNo
        ZpiderImportProfileNo EdiTestYesNo EDITestMode ElectronicInvoiceActive
        ElectronicInvoiceByMailYesNo CustProfilesOverrideChainProfiles
        ZUsrEDIProfile SwiftCodeNo ContactsUpdatedInBizWeb
        FinancialDataUpdatedInBizWeb MaindataUpdatedInBizWeb AnnualSales Result
        NoOfEmployees CreditBlockAllowOfferAndNewOrders ContactNoConfirmOrder
        ContactNoPickingList MDM_Deleted MDM_Version MDM_SyncVersion ZUsrVisPaaWeb
      ]

      dates = %w[
        LastMovementDate RegistrationDate LastSubscriptionInvoiceDate
        CreditControlLastActionTime DateUpdatedContactData
        DateUpdatedFinancialData LastUpdatedInBizWeb LastupdatedFromBizWeb
        DateLastFinancialStatement
      ]

      zeroed = zeroes.each_with_object({}) do |name, attributes|
        attributes[name] = 0
        attributes
      end

      dated = dates.each_with_object({}) do |name, atts|
        atts[name] = Time.at(0).utc
        atts
      end.merge(zeroed)

      dated.merge(
        'FormProfileCustNo' => 1, 'CustomerProfileNo' => 1, 'CountryNo' => 578,
        'TermsOfPayCustNo' => 1, 'PriceCode' => 1, 'CurrencyNo' => 578,
        'RegistrationDate' => Date.today, 'DebtCollectionGrpNo' => 1,
        'UtilityBits' => "\x00\x00\x00\x00\x00\x00", 'RemittanceProfileNo' => 1,
        'RemainderOrderYesNo' => 2, 'PrintProfileNo' => 2, 'BusinessNo' => 15,
        'GLAccountRec' => 1210, 'CustomerGrpNo' => 5
      )
    end

    protected

    # New primary key minium 10000
    # TODO maximum 50000
    def generate_primary_key
      self[self.class.primary_key] ||= self.class.new_primary_key(10_000)
    end

    # Always set sortname equal to name
    def set_sort_name
      self.SortName = self.Name
    end

    # Set default values for known fields
    def set_default_values
      self.class.defaults.each do |key, default|
        self[key] ||= default
      end
    end
  end
end
