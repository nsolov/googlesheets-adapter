Class GoogleSheets.Demo.Production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="GoogleSheets.Demo.Production" TestingEnabled="true" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="GoogleSheets.BusinessOperation" Category="" ClassName="GoogleSheets.BusinessOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="KeyFile"></Setting>
    <Setting Target="Host" Name="SpreadsheetId"></Setting>
  </Item>
  <Item Name="GoogleSheets.Demo.BusinessService" Category="" ClassName="GoogleSheets.Demo.BusinessService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="IDColumn"></Setting>
    <Setting Target="Adapter" Name="RequiredColumns"></Setting>
    <Setting Target="Adapter" Name="SheetTitle"></Setting>
    <Setting Target="Adapter" Name="SpreadsheetId"></Setting>
    <Setting Target="Adapter" Name="KeyFile"></Setting>
  </Item>
</Production>
}

}
