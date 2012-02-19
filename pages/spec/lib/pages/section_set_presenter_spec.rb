require "spec_helper"

module Refinery
  module Pages
    describe SectionSetPresenter do
      let(:part)             { double(PagePart, :body => 'part_body', :title => 'A Wonderful Page Part') }
      let(:part2)            { double(PagePart, :body => 'part_body2', :title => 'Another Wonderful Page Part') }
      let(:title)            { 'This Great Page' }

      describe "when building for page" do
        let(:page_with_one_part) { double(Page, :parts => [part]) }

        it "adds page title section before page parts" do
          set = SectionSetPresenter.build_for_page(page_with_one_part, title)
          set.first.fallback_html.should == title
        end

        it "adds a section for each page part" do
          page = double(Page, :parts => [part, part2])
          set = SectionSetPresenter.build_for_page(page, title)
          set[1].fallback_html.should == 'part_body'
          set[2].fallback_html.should == 'part_body2'
        end

        it "adds body content left and right after page parts" do
          set = SectionSetPresenter.build_for_page(page_with_one_part, title)
          set[2].id.should == :body_content_left
          set[3].id.should == :body_content_right
        end

        it "doesnt add page parts if page is nil" do
          set = SectionSetPresenter.build_for_page(nil, title)
          set[1].id.should == :body_content_left
        end

        it "doesnt add title if it is blank" do
          set = SectionSetPresenter.build_for_page(nil, '')
          set[0].id.should == :body_content_left
        end
      end

      describe "when building css classes for blank sections" do
        let(:section)        { double(SectionPresenter, :not_present_css_class => 'no_section1') }

        it "includes css class for any section which doesnt have content" do
          section.stub(:has_content?).with(true).and_return(false)
          set = SectionSetPresenter.new
          set << section

          set.blank_section_css_classes(true).should == ['no_section1']
        end

        it "doesnt include sections which have content" do
          section.stub(:has_content?).with(true).and_return(true)
          set = SectionSetPresenter.new
          set << section

          set.blank_section_css_classes(true).should be_empty
        end
      end

      describe "when hiding sections" do
        let(:section1)  { double(SectionPresenter, :id => 'foo') }
        let(:section2)  { double(SectionPresenter, :id => 'bar') }

        before do
          @set = SectionSetPresenter.new
          @set << section1
          @set << section2
        end

        it "hides a section specified by id" do
          section2.should_receive(:hide)
          @set.hide_sections('bar')
        end
      end

      describe "when fetching template overrides" do
        before do
          @set = SectionSetPresenter.new
        end

        it "yields a section with an id and stores the result in its override html" do
          section = double(SectionPresenter, :id => 'foo')
          section.should_receive(:override_html=).with('some override')
          @set << section

          @set.fetch_template_overrides do |section_id|
            section_id.should == 'foo'
            'some override'
          end
        end

        it "doesnt yield a section without an id" do
          section = double(SectionPresenter, :id => nil)
          section.should_receive(:override_html=).never
          @set << section

          @set.fetch_template_overrides do |section_id|
            raise "this should not occur"
          end
        end
      end
    end
  end
end
