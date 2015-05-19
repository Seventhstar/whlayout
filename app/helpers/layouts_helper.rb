module LayoutsHelper

	def element_name(lay_el)

		if lay_el.present?
			Element.find(lay_el.element_id).name if lay_el.element_id.present?
		else
			""
		end
	end

end
