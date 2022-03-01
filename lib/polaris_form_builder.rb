class PolarisFormBuilder < ActionView::Helpers::FormBuilder
  def polaris_text_field(method, options = {}, &block)
    help_text = options.delete(:help)
    
    @template.content_tag(:div, class: "Polaris-FormLayout__Item") do
      @template.safe_join([
        @template.content_tag(:div, class: "Polaris-Labelled__LabelWrapper") do
          @template.content_tag(:div, class: "Polaris-Label") do
            label(method, class: "Polaris-Label__Text")
          end
        end,

        @template.content_tag(:div, class: "Polaris-Connected") do
          @template.content_tag(:div, class: "Polaris-Connected__Item Polaris-Connected__Item--primary") do

            classes = ["Polaris-TextField"]
            classes << "Polaris-TextField--error" if @object && @object.errors.details[method.to_sym].present?
            
            @template.content_tag(:div, class: classes) do
              @template.safe_join([
                text_field(method, options.merge(class: "Polaris-TextField__Input")),
                @template.content_tag(:div, nil, class: "Polaris-TextField__Backdrop")
              ])
            end
          end
        end,

        if help_text
          @template.content_tag(:div, class: "Polaris-Labelled__HelpText") do
            @template.raw(help_text)
          end
        end
      ].compact)
    end
  end

  def polaris_check_box(method, options = {}, &block)
    icon = <<-ICON
      <svg viewBox="0 0 20 20" class="Polaris-Icon__Svg" focusable="false" aria-hidden="true">
        <path d="m8.315 13.859-3.182-3.417a.506.506 0 0 1 0-.684l.643-.683a.437.437 0 0 1 .642 0l2.22 2.393 4.942-5.327a.436.436 0 0 1 .643 0l.643.684a.504.504 0 0 1 0 .683l-5.91 6.35a.437.437 0 0 1-.642 0"></path>
      </svg>
    ICON

    @template.content_tag(:div, class: "Polaris-FormLayout__Item") do
      @template.label(@object_name, method, class: "Polaris-Choice") do
        @template.safe_join([
          @template.content_tag(:span, class: "Polaris-Choice__Control") do
            @template.content_tag(:span, class: "Polaris-Checkbox") do
              @template.safe_join([
                check_box(method, class: "Polaris-Checkbox__Input"),
                @template.content_tag(:span, nil, class: "Polaris-Checkbox__Backdrop"),
                @template.content_tag(:span, class: "Polaris-Checkbox__Icon") do
                  @template.content_tag(:span, @template.raw(icon), class: "Polaris-Icon")
                end
              ])
            end
          end,
          @template.content_tag(:span, @object.class.human_attribute_name(method), class: "Polaris-Choice__Label")
        ])
      end
    end
  end

  def polaris_select(method, choices, options = {}, html_options = {}, &block)
    help_text = options.delete(:help)

    icon = <<-ICON
      <svg viewBox="0 0 20 20" class="Polaris-Icon__Svg" focusable="false" aria-hidden="true">
        <path d="M7.676 9h4.648c.563 0 .879-.603.53-1.014L10.531 5.24a.708.708 0 0 0-1.062 0L7.145 7.986C6.798 8.397 7.113 9 7.676 9zm4.648 2H7.676c-.563 0-.878.603-.53 1.014l2.323 2.746c.27.32.792.32 1.062 0l2.323-2.746c.349-.411.033-1.014-.53-1.014z"></path>
      </svg>
    ICON

    classes = ["Polaris-Select"]
    classes << "Polaris-Select--error" if @object && @object.errors.details[method.to_sym].present?

    @template.content_tag(:div, class: "Polaris-FormLayout__Item") do
      @template.safe_join([
        @template.content_tag(:div, class: "Polaris-Labelled__LabelWrapper") do
          @template.content_tag(:div, class: "Polaris-Label") do
            @template.label(@object_name, method, class: "Polaris-Label__Text")
          end
        end,
        
        @template.content_tag(:div, class: classes) do
          @template.safe_join([
            select(method, choices, options, { class: "Polaris-Select__Input" }.merge(html_options) ),

            @template.content_tag(:div, class: "Polaris-Select__Content") do
              @template.safe_join([
                @template.content_tag(:span, nil, class: "Polaris-Select__SelectedOption"),
                @template.content_tag(:span, class: "Polaris-Select__Icon") do
                  @template.content_tag(:span, @template.raw(icon), class: "Polaris-Icon")
                end
              ])
            end,

            @template.content_tag(:span, nil, class: "Polaris-Select__Backdrop")
          ])
        end,

        if help_text
          @template.content_tag(:div, class: "Polaris-Labelled__HelpText") do
            @template.raw(help_text)
          end
        end
      ].compact)
    end
  end
end
