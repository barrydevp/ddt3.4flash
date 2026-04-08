package store.fineStore.view
{
   import flash.display.DisplayObject;
   
   import bagAndInfo.cell.BagCell;
   
   import ddt.data.goods.ItemTemplateInfo;
   
   public class GhostEquipListCell extends BagCell
   {
      public function GhostEquipListCell(param1:int, param2:ItemTemplateInfo = null, param3:Boolean = true, param4:DisplayObject = null, param5:Boolean = true)
      {
         super(param1,param2,param3,param4,param5);
         _isShowIsUsedBitmap = true;
      }
   }
}
