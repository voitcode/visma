class Visma::PostingTemplateArticle < ActiveRecord::Base
  establish_connection(:visma)
  self.table_name = "KuraasAS.PostingTemplateArticle"

  has_many :article, foreign_key: "PostingTemplateNo", primary_key: "PostingTemplateNo"

  belongs_to :output_tax_class, foreign_key: "OutputTaxClassNo", primary_key: "TaxClassNo", class_name: "TaxClass"
  belongs_to :input_tax_class, foreign_key: "InputTaxClassNo", primary_key: "TaxClassNo", class_name: "TaxClass"
end
