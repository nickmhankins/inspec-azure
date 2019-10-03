tenant_id = attribute('tenant_id', default: nil)
parent_mg = attribute('parent_mg', default: nil)
child1_mg = attribute('child1_mg', default: nil)
child2_mg = attribute('child2_mg', default: nil)
parent_dn = attribute('parent_dn', default: nil)
mg_type   = '/providers/Microsoft.Management/managementGroups'

control 'azurerm_management_group' do
  describe azurerm_management_group(group_id: parent_mg, expand: 'children', recurse: true) do
    it                            { should exist }
    its('id')                     { should eq "#{mg_type}/#{parent_mg}" }
    its('type')                   { should eq mg_type   }
    its('name')                   { should eq parent_mg }
    its('display_name')           { should eq parent_dn }
    its('tenant_id')              { should eq tenant_id }
    its('children_ids')           { should include "#{mg_type}/#{child1_mg}" }
    its('children_ids')           { should include "#{mg_type}/#{child2_mg}" }
    its('children_names')         { should include child1_mg }
    its('children_names')         { should include child2_mg }
    its('children_types')         { should include mg_type }
    its('children_display_names') { should include 'Management Group Child 1' }
    its('children_display_names') { should include 'Management Group Child 2' }
  end

  describe azurerm_management_group(group_id: child1_mg, expand: 'children', recurse: true) do
    it                            { should exist }
    its('id')                     { should eq "#{mg_type}/#{child1_mg}" }
    its('type')                   { should eq mg_type   }
    its('name')                   { should eq child1_mg }
    its('tenant_id')              { should eq tenant_id }
    its('parent_name')            { should eq parent_mg }
    its('parent_id')              { should eq "#{mg_type}/#{parent_mg}" }
    its('display_name')           { should eq 'Management Group Child 1' }
    its('parent_display_name')    { should eq 'Management Group Parent' }
    its('children_display_names') { should eq [] }
    its('children_ids')           { should eq [] }
    its('children_names')         { should eq [] }
    its('children_types')         { should eq [] }
  end

  describe azurerm_management_group(group_id: child2_mg, expand: 'children', recurse: true) do
    it                            { should exist }
    its('id')                     { should eq "#{mg_type}/#{child2_mg}" }
    its('type')                   { should eq mg_type   }
    its('name')                   { should eq child2_mg }
    its('tenant_id')              { should eq tenant_id }
    its('parent_name')            { should eq parent_mg }
    its('parent_id')              { should eq "#{mg_type}/#{parent_mg}" }
    its('display_name')           { should eq 'Management Group Child 2' }
    its('parent_display_name')    { should eq 'Management Group Parent' }
    its('children_display_names') { should eq [] }
    its('children_ids')           { should eq [] }
    its('children_names')         { should eq [] }
    its('children_types')         { should eq [] }
  end
end