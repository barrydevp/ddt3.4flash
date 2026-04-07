package store.view.exalt
{
   import com.greensock.TweenMax;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   
   import bagAndInfo.cell.BagCell;
   
   import baglocked.BaglockedManager;
   
   import ddt.command.QuickBuyFrame;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
   import ddt.events.CellEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   
   import store.HelpFrame;
   import store.StoreBagBgWHPoint;
   import store.StrengthDataManager;
   import store.data.StoreEquipExperience;
   import store.events.StoreIIEvent;
   
   public class StoreExaltBG extends Sprite implements Disposeable
   {
	  public static const INTERVAL:int = 1400;
      
//      private var _bg:Bitmap;
      
      private var _bagList:ExaltBagListView;
      
      private var _proBagList:ExaltBagListView;
      
      private var _leftDrapSprite:ExaltLeftDragSprite;
      
      private var _rightDrapSprite:ExaltRightDragSprite;
	  
	  private var _equipCellBg:Image;
	  
	  private var _itemCellBg:Bitmap;
	  
	  private var _equipCellText:FilterFrameText;
	  
	  private var _rockText:FilterFrameText;
      
      private var _itemCell:ExaltItemCell;
      
      private var _equipCell:ExaltEquipCell;
      
      private var _continuousBtn:SelectedCheckButton;
      
      private var _doBtn:BaseButton;
	  
	  private var _buyBtn:SimpleBitmapButton;
	  
	  private var _quick:QuickBuyFrame;
      
	  private var _progressBar:store.view.exalt.StoreExaltProgressBar;
	  
//      private var _tip:ExaltTips;
	  
	  private var _movieI:MovieClip;
	  
	  private var _movieII:MovieClip;
	  
	  private var _luckyText:FilterFrameText;
      
      private var _helpBtn:BaseButton;
      
      private var _isDispose:Boolean = false;
      
      private var _equipBagInfo:BagInfo;
      
//      public var msg_txt:ScaleFrameImage;
      
      private var bagBg:ScaleFrameImage;
      
      private var _bgShape:Shape;
      
      private var _bgPoint:StoreBagBgWHPoint;
	  
	  private var _lastDoAt:int = 0;
      
      public function StoreExaltBG()
      {
         super();
         this.mouseEnabled = false;
         this.initView();
         this.initEvent();
         this.createAcceptDragSprite();
      }
      
      private function initView() : void
      {
         this.bagBg = ComponentFactory.Instance.creatComponentByStylename("store.bagBG");
         this._bgPoint = ComponentFactory.Instance.creatCustomObject("store.bagBGWHPoint");
         this._bgShape = new Shape();
         this.bagBg.addChild(this._bgShape);
         this.bagBg.x = 368;
         this.bagBg.y = 15;
         addChild(this.bagBg);
         this._bgShape.graphics.clear();
         this._bgShape.graphics.beginFill(int(this._bgPoint.pointArr[0]));
         this._bgShape.graphics.drawRect(Number(this._bgPoint.pointArr[1]),Number(this._bgPoint.pointArr[2]),Number(this._bgPoint.pointArr[3]),Number(this._bgPoint.pointArr[4]));
         this._bgShape.graphics.drawRect(Number(this._bgPoint.pointArr[5]),Number(this._bgPoint.pointArr[6]),Number(this._bgPoint.pointArr[7]),Number(this._bgPoint.pointArr[8]));
//         this._bg = ComponentFactory.Instance.creatBitmap("asset.wishBead.leftViewBg");
		 this._buyBtn = UICreatShortcut.creatAndAdd("ddt.store.view.exalt.buyBtn",this);
		 this._progressBar = UICreatShortcut.creatAndAdd("store.view.exalt.storeExaltProgressBar",this);
		 this._progressBar.progress(0,0);
//         this.msg_txt = ComponentFactory.Instance.creatComponentByStylename("store.bagMsg1");
//         this.msg_txt.x = 452;
//         this.msg_txt.y = 17;
//         addChild(this.msg_txt);
//         this.msg_txt.setFrame(1);
         this._bagList = new ExaltBagListView(BagInfo.EQUIPBAG,7,21);
         PositionUtils.setPos(this._bagList,"wishBeadMainView.bagListPos");
         this.refreshBagList();
		 addChild(this._bagList);
         this._proBagList = new ExaltBagListView(BagInfo.PROPBAG,7,21);
         PositionUtils.setPos(this._proBagList,"wishBeadMainView.proBagListPos");
         this._proBagList.setData(ExaltManager.instance.getExaltItemData());
		 
		 this._equipCellBg = UICreatShortcut.creatAndAdd("ddtstore.StoreIIStrengthBG.stoneCellBg",this);
		 PositionUtils.setPos(this._equipCellBg,"ddtstore.StoreIIStrengthBG.EquipmentCellBgPos");
		 this._equipCellText = UICreatShortcut.creatTextAndAdd("ddtstore.StoreIIStrengthBG.StrengthenEquipmentCellText",LanguageMgr.GetTranslation("store.Strength.StrengthenCurrentEquipmentCellText"),this);
		 PositionUtils.setPos(this._equipCellText,"ddtstore.StoreIIStrengthBG.StrengthenEquipmentCellTextPos");
		 this._equipCell = new ExaltEquipCell(0,null,true,new Bitmap(new BitmapData(60,60,true,0)),false);
         this._equipCell.BGVisible = false;
         PositionUtils.setPos(this._equipCell,"store.view.exalt.StoreExaltBG.point1");
         this._equipCell.setContentSize(68,68);
         this._equipCell.PicPos = new Point(-3,-5);
		 
		 this._itemCellBg = UICreatShortcut.creatAndAdd("asset.ddtstore.GoodPanel",this);
		 PositionUtils.setPos(this._itemCellBg,"ddtstore.StoreIIStrengthBG.StrengthCellBg1Point");
		 this._rockText = UICreatShortcut.creatTextAndAdd("ddtstore.StoreIIStrengthBG.GoodCellText",LanguageMgr.GetTranslation("store.Strength.GoodPanelText.StoreExaltRock"),this);
		 PositionUtils.setPos(this._rockText,"ddtstore.StoreIIStrengthBG.StrengthStoneText1Point");
         this._itemCell = new ExaltItemCell(0,null,true,new Bitmap(new BitmapData(60,60,true,0)),false);
         PositionUtils.setPos(this._itemCell,"store.view.exalt.StoreExaltBG.point0");
         this._itemCell.BGVisible = false;
		 
		 this._continuousBtn = UICreatShortcut.creatAndAdd("ddt.store.view.exalt.SelectedCheckButton",this);
		 this._continuousBtn.selected = false;
         this._doBtn = ComponentFactory.Instance.creatComponentByStylename("ddt.store.view.exalt.exaltBtn");
         this._doBtn.enable = false;
		 addChild(this._doBtn);
		 this._helpBtn = UICreatShortcut.creatAndAdd("ddtstore.HelpButton",this);
//         addChild(this._bg);
         addChild(this._proBagList);
         addChild(this._equipCell);
         addChild(this._itemCell);
         
//         this._tip = ComponentFactory.Instance.creat("store.forge.wishBead.WishTip");
//         LayerManager.Instance.getLayerByType(LayerManager.STAGE_TOP_LAYER).addChild(this._tip);

      }
      
      public function hide() : void
      {
         this.visible = false;
      }
      
      private function refreshBagList() : void
      {
         this._equipBagInfo = ExaltManager.instance.getCanExaltData();
         this._bagList.setData(this._equipBagInfo);
      }
      
      private function initEvent() : void
      {
         this._bagList.addEventListener(CellEvent.ITEM_CLICK,this.cellClickHandler,false,0,true);
         this._bagList.addEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick,false,0,true);
         this._equipCell.addEventListener(Event.CHANGE,this.itemEquipChangeHandler,false,0,true);
         this._proBagList.addEventListener(CellEvent.ITEM_CLICK,this.cellClickHandler,false,0,true);
         this._proBagList.addEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick,false,0,true);
         this._itemCell.addEventListener(Event.CHANGE,this.itemEquipChangeHandler,false,0,true);
         this._doBtn.addEventListener(MouseEvent.CLICK,this.doHandler,false,0,true);
		 StrengthDataManager.instance.addEventListener(StoreIIEvent.EXALT_FINISH,this.__exaltFinish);
		 StrengthDataManager.instance.addEventListener(StoreIIEvent.EXALT_FAIL,this.__exaltFail);
         PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE,this.propInfoChangeHandler);
         PlayerManager.Instance.Self.Bag.addEventListener(BagEvent.UPDATE,this.bagInfoChangeHandler);
		 this._buyBtn.addEventListener(MouseEvent.CLICK,this.__onBuyClick);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__clickHelp,false,0,true);
      }
      
      private function bagInfoChangeHandler(param1:BagEvent) : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:BagInfo = null;
         var _loc5_:Dictionary = param1.changedSlots;
         for each(_loc3_ in _loc5_)
         {
            _loc2_ = _loc3_;
         }
         if(Boolean(_loc2_) && !PlayerManager.Instance.Self.Bag.items[_loc2_.Place])
         {
            if(Boolean(this._equipCell.info) && (this._equipCell.info as InventoryItemInfo).Place == _loc2_.Place)
            {
               this._equipCell.info = null;
            }
            else
            {
               this.refreshBagList();
            }
         }
         else
         {
            _loc4_ = ExaltManager.instance.getCanExaltData();
            if(_loc4_.items.length != this._equipBagInfo.items.length)
            {
               this._equipBagInfo = _loc4_;
               this._bagList.setData(this._equipBagInfo);
            }
         }
         var _loc6_:InventoryItemInfo = this._equipCell.itemInfo;
         if(Boolean(_loc6_) && _loc6_.isGold)
         {
            this._equipCell.info = null;
            this._equipCell.info = _loc6_;
         }
      }
	  
	  protected function __onBuyClick(param1:MouseEvent) : void
	  {
		  SoundManager.instance.playButtonSound();
		  this.buyRock();
	  }
      
	  private function buyRock() : void
	  {
		  if(PlayerManager.Instance.Self.bagLocked)
		  {
			  BaglockedManager.Instance.show();
			  return;
		  }
		  this._quick = ComponentFactory.Instance.creatCustomObject("core.QuickFrame");
		  this._quick.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
		  this._quick.itemID = EquipType.EXALT_ROCK;
		  LayerManager.Instance.addToLayer(this._quick,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
	  }
	  
      private function __clickHelp(param1:MouseEvent) : void
      {
		  SoundManager.instance.playButtonSound();
		  var _loc2_:MovieClip = ComponentFactory.Instance.creatCustomObject("store.view.exalt.HelpBG");
		  var _loc3_:HelpFrame = ComponentFactory.Instance.creat("ddtstore.HelpFrame");
		  _loc3_.height = 482;
		  _loc3_.setView(_loc2_);
		  _loc3_.titleText = LanguageMgr.GetTranslation("store.StoreExaltBG.say");
		  _loc3_.setButtonPos(165,439);
		  _loc3_.addEventListener(FrameEvent.RESPONSE,this.__frameEvent);
		  LayerManager.Instance.addToLayer(_loc3_,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND,true);
	  }
	  
	  protected function __frameEvent(param1:FrameEvent) : void
	  {
		  SoundManager.instance.playButtonSound();
		  var _loc2_:Disposeable = param1.target as Disposeable;
		  _loc2_.dispose();
		  _loc2_ = null;
	  }
      
      private function propInfoChangeHandler(param1:BagEvent) : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:InventoryItemInfo = null;
         var _loc5_:Dictionary = param1.changedSlots;
         for each(_loc3_ in _loc5_)
         {
            _loc2_ = _loc3_;
         }
         if(Boolean(_loc2_) && !PlayerManager.Instance.Self.PropBag.items[_loc2_.Place])
         {
            if(Boolean(this._itemCell.info) && (this._itemCell.info as InventoryItemInfo).Place == _loc2_.Place)
            {
               this._itemCell.info = null;
            }
            else
            {
               this._proBagList.setData(ExaltManager.instance.getExaltItemData());
            }
         }
         else
         {
            if(!this._itemCell || !this._itemCell.info)
            {
               return;
            }
            _loc4_ = this._itemCell.info as InventoryItemInfo;
            if(!PlayerManager.Instance.Self.PropBag.items[_loc4_.Place])
            {
               this._itemCell.info = null;
            }
            else
            {
               this._itemCell.setCount(_loc4_.Count);
            }
         }
      }
      
      private function judgeAgain() : void
      {
         if(this._isDispose)
         {
            return;
         }
         if(this._continuousBtn.selected)
         {
            if(!this._itemCell.info || this._itemCell.itemInfo.Count <= 0)
            {
			   MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.exalt.warning"));
			   this.judgeDoBtnStatus();
               return;
            }
			setTimeout(this.exaltHandler,INTERVAL);
         }
         else
         {
            this.judgeDoBtnStatus();
         }
      }
	  
	  
	  private function doHandler(param1:MouseEvent) : void
	  {
		  this.exaltHandler()
	  }
      
      private function exaltHandler() : void
      {
         var _loc2_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
		 var nowAt:int = getTimer();
		 if(nowAt - this._lastDoAt < INTERVAL)
		 {
			 MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.storeIIStrength.startStrengthClickTimerMsg"));
			 return;
		 }
		 this._lastDoAt = nowAt;
         if(!this._equipCell.info || !this._itemCell.info || this._itemCell.itemInfo.Count <= 0)
         {
			MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.exalt.warning"));
            return;
         }
		 if(this._equipCell.itemInfo.StrengthenLevel >= 15)
		 {
			 MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.exalt.warningI"));
			 return;
		 }
		 if(int(this._itemCell.info.Property3) != 0)
		 {
			 if(this._equipCell.itemInfo.StrengthenLevel - 11 == int(this._itemCell.info.Property3))
			 {
				 return;
			 }
			 MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.exalt.warningII"));
			 return;
		 }
         if(!this._equipCell.itemInfo.IsBinds)
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.BindsInfo"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
            _loc2_.moveEnable = false;
            _loc2_.addEventListener(FrameEvent.RESPONSE,this.__confirm,false,0,true);
         }
         else
         {
            this.sendMess();
         }
      }
      
      private function __confirm(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__confirm);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.sendMess();
         }
      }
      
      private function sendMess() : void
      {
         this._doBtn.enable = false;
         var _loc1_:InventoryItemInfo = this._equipCell.itemInfo;
         var _loc2_:InventoryItemInfo = this._itemCell.itemInfo;
		 this.showExaltMovie();
         SocketManager.Instance.out.sendItemExalt(_loc1_.Place,_loc1_.BagType,_loc2_.Place,_loc2_.BagType);
      }
	  
	  private function showSuccessMovie() : void
	  {
		  if(Boolean(this._movieI))
		  {
			  this._movieI.stop();
		  }
		  ObjectUtils.disposeObject(this._movieI);
		  this._movieI = null;
		  this._movieI = UICreatShortcut.creatAndAdd("asset.ddtstore.exalt.movieI",this);
		  this._movieI.gotoAndPlay(1);
		  this._movieI.addFrameScript(this._movieI.totalFrames - 1,this.disposeSuccessMovie);
	  }
	  
	  private function disposeSuccessMovie() : void
	  {
		  if(Boolean(this._movieI))
		  {
			  this._movieI.stop();
		  }
		  ObjectUtils.disposeObject(this._movieI);
		  this._movieI = null;
	  }
	  
	  private function showExaltMovie() : void
	  {
		  if(Boolean(this._movieII))
		  {
			  this._movieII.stop();
		  }
		  else
		  {
			  this._movieII = UICreatShortcut.creatAndAdd("asset.ddtstore.exalt.movieII",this);
		  }
		  this._movieII.gotoAndPlay(1);
		  this._movieII.addFrameScript(this._movieII.totalFrames - 1,this.disposeExaltMovie);
	  }
	  
	  private function disposeExaltMovie() : void
	  {
		  if(Boolean(this._movieII))
		  {
			  this._movieII.stop();
		  }
		  ObjectUtils.disposeObject(this._movieII);
		  this._movieII = null;
	  }
      
      private function itemEquipChangeHandler(param1:Event) : void
      {
		 var _loc2_:ExaltEquipCell = null;
		 var _loc3_:InventoryItemInfo = null;
		 var _loc4_:int = 0;
		 if(param1.currentTarget is ExaltEquipCell)
		 {
			 _loc2_ = param1.currentTarget as ExaltEquipCell;
			 _loc3_ = _loc2_.itemInfo;
			 if(Boolean(_loc3_))
			 {
				 _loc4_ = int(StoreEquipExperience.expericence[_loc3_.StrengthenLevel + 1]);
				 if(_loc4_ == 0)
				 {
					 this._progressBar.progress(0,0);
				 }
				 else
				 {
					 this._progressBar.progress(_loc3_.StrengthenExp,_loc4_);
				 }
			 }
			 else
			 {
				 this._progressBar.progress(0,0);
			 }
			 dispatchEvent(new Event(Event.CHANGE));
		 }
		 this.judgeDoBtnStatus();
      }
	  
	  protected function __exaltFinish(param1:StoreIIEvent) : void
	  {
		  this._continuousBtn.selected = false;
		  this.showSuccessMovie();
		  this.judgeDoBtnStatus();
	  }
	  
	  protected function __exaltFail(param1:StoreIIEvent) : void
	  {
		  var _loc3_:int = 0;
		  var _loc4_:int = 0;
		  ObjectUtils.disposeObject(this._luckyText);
		  this._luckyText = null;
		  this._luckyText = ComponentFactory.Instance.creatComponentByStylename("ddt.store.view.exalt.luckyText");
		  this._luckyText.text = LanguageMgr.GetTranslation("store.view.exalt.luckyTips",int(param1.data));
		  var _loc2_:int = this._luckyText.width;
		  _loc3_ = this._luckyText.height;
		  _loc4_ = this._luckyText.y;
		  this._luckyText.width /= 2;
		  this._luckyText.height /= 2;
		  this._luckyText.alpha = 0.5;
		  TweenMax.fromTo(this._luckyText,2,{
			  "y":_loc4_ - 30,
			  "alpha":1,
			  "width":_loc2_,
			  "height":_loc3_
		  },{
			  "y":_loc4_ - 60,
			  "alpha":0,
			  "width":0,
			  "height":0,
			  "onComplete":this.onComplete
		  });
		  addChild(this._luckyText);
		  SoundManager.instance.play("171");
		  this.judgeAgain();
	  }
	  
	  private function onComplete() : void
	  {
		  ObjectUtils.disposeObject(this._luckyText);
		  this._luckyText = null;
	  }
      
      private function judgeDoBtnStatus() : void
      {
         if(Boolean(this._equipCell.info) && Boolean(this._itemCell.info) && this._itemCell.itemInfo.Count > 0)
         {
            this._doBtn.enable = true;
         }
         else
         {
//			this._continuousBtn.selected = false;
            this._doBtn.enable = false;
         }
      }
      
      protected function __cellDoubleClick(param1:CellEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:String = "";
         if(param1.target == this._proBagList)
         {
            _loc2_ = ExaltManager.ITEM_MOVE;
         }
         else
         {
            _loc2_ = ExaltManager.EQUIP_MOVE;
         }
         var _loc3_:ExaltEvent = new ExaltEvent(_loc2_);
         var _loc4_:BagCell = param1.data as BagCell;
         _loc3_.info = _loc4_.info as InventoryItemInfo;
         _loc3_.moveType = 1;
		 ExaltManager.instance.dispatchEvent(_loc3_);
      }
      
      private function cellClickHandler(param1:CellEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BagCell = param1.data as BagCell;
         _loc2_.dragStart();
      }
      
      private function createAcceptDragSprite() : void
      {
         this._leftDrapSprite = new ExaltLeftDragSprite();
         this._leftDrapSprite.mouseEnabled = false;
         this._leftDrapSprite.mouseChildren = false;
         this._leftDrapSprite.graphics.beginFill(0,0);
         this._leftDrapSprite.graphics.drawRect(0,0,347,404);
         this._leftDrapSprite.graphics.endFill();
         PositionUtils.setPos(this._leftDrapSprite,"wishBeadMainView.leftDrapSpritePos");
         addChild(this._leftDrapSprite);
         this._rightDrapSprite = new ExaltRightDragSprite();
         this._rightDrapSprite.mouseEnabled = false;
         this._rightDrapSprite.mouseChildren = false;
         this._rightDrapSprite.graphics.beginFill(0,0);
         this._rightDrapSprite.graphics.drawRect(0,0,374,407);
         this._rightDrapSprite.graphics.endFill();
         PositionUtils.setPos(this._rightDrapSprite,"wishBeadMainView.rightDrapSpritePos");
         addChild(this._rightDrapSprite);
      }
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
         if(param1)
         {
            if(!this._isDispose)
            {
               this.refreshListData();
               PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE,this.propInfoChangeHandler);
               PlayerManager.Instance.Self.Bag.addEventListener(BagEvent.UPDATE,this.bagInfoChangeHandler);
            }
         }
         else
         {
            this.clearCellInfo();
            PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.UPDATE,this.propInfoChangeHandler);
            PlayerManager.Instance.Self.Bag.removeEventListener(BagEvent.UPDATE,this.bagInfoChangeHandler);
         }
      }
      
      public function clearCellInfo() : void
      {
         if(Boolean(this._equipCell))
         {
            this._equipCell.clearInfo();
         }
         if(Boolean(this._itemCell))
         {
            this._itemCell.clearInfo();
         }
      }
      
      public function refreshListData() : void
      {
         if(Boolean(this._bagList))
         {
            this.refreshBagList();
         }
         if(Boolean(this._proBagList))
         {
            this._proBagList.setData(ExaltManager.instance.getExaltItemData());
         }
      }
      
      private function removeEvent() : void
      {
         this._bagList.removeEventListener(CellEvent.ITEM_CLICK,this.cellClickHandler);
         this._bagList.removeEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         this._equipCell.removeEventListener(Event.CHANGE,this.itemEquipChangeHandler);
         this._proBagList.removeEventListener(CellEvent.ITEM_CLICK,this.cellClickHandler);
         this._proBagList.removeEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         this._itemCell.removeEventListener(Event.CHANGE,this.itemEquipChangeHandler);
         this._doBtn.removeEventListener(MouseEvent.CLICK,this.doHandler);
		 this._buyBtn.removeEventListener(MouseEvent.CLICK,this.__onBuyClick);
		 StrengthDataManager.instance.removeEventListener(StoreIIEvent.EXALT_FINISH,this.__exaltFinish);
		 StrengthDataManager.instance.removeEventListener(StoreIIEvent.EXALT_FAIL,this.__exaltFail);
         PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.UPDATE,this.propInfoChangeHandler);
         PlayerManager.Instance.Self.Bag.removeEventListener(BagEvent.UPDATE,this.bagInfoChangeHandler);
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__clickHelp);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
//         ObjectUtils.disposeObject(this._tip);
//         this._tip = null;
//         this._bg = null;
         this._bagList = null;
         this._proBagList = null;
         this._leftDrapSprite = null;
         this._rightDrapSprite = null;
         this._itemCell = null;
         this._equipCell = null;
		 this._equipCellBg = null;
		 this._itemCellBg = null;
		 this._equipCellText = null;
		 this._rockText = null;
         this._continuousBtn = null;
         this._doBtn = null;
		 this._buyBtn = null;
		 ObjectUtils.disposeObject(this._quick);
		 this._quick = null;
         this._helpBtn = null;
         this._equipBagInfo = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         this._isDispose = true;
      }
   }
}
