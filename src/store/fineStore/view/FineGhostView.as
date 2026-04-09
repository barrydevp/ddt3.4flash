package store.fineStore.view
{
	import com.greensock.TweenMax;
	import com.pickgliss.ui.ComponentFactory;
	import com.pickgliss.ui.controls.BaseButton;
	import com.pickgliss.ui.controls.SelectedCheckButton;
	import com.pickgliss.ui.controls.SimpleBitmapButton;
	import com.pickgliss.ui.core.Disposeable;
	import com.pickgliss.ui.image.ScaleFrameImage;
	import com.pickgliss.ui.text.FilterFrameText;
	import com.pickgliss.utils.ObjectUtils;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	import bagAndInfo.cell.BagCell;

	import baglocked.BaglockedManager;

	import ddt.data.BagInfo;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.events.BagEvent;
	import ddt.events.CEvent;
	import ddt.events.CellEvent;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SoundManager;
	import ddt.utils.HelpFrameUtils;
	import ddt.utils.PositionUtils;

	import road7th.utils.MathUtils;

	import store.equipGhost.EquipGhostEvent;
	import store.equipGhost.EquipGhostManager;
	import store.forge.ForgeRightBgView;
	import store.view.StoneCellFrame;

	public final class FineGhostView extends Sprite implements Disposeable
	{
		public static const INTERVAL:int = 1400;

		private var _leftDrapSprite:GhostEquipLeftDragSprite;
		private var _rightDrapSprite:GhostEquipRightDragSprite;

		private var _rightBgView:ForgeRightBgView;

		private var bagBg:ScaleFrameImage;

		private var _luckyStoneCell:StoneCellFrame;

		private var _ghostStoneCell:StoneCellFrame;

		private var _equipmentCell:StoneCellFrame;

		private var _ghostBtn:SimpleBitmapButton;

		private var _ghostHelpBtn:BaseButton;

		private var _ratioTxt:FilterFrameText;

		private var _continuesBtn:SelectedCheckButton;

		private var _isDispose:Boolean = false;

		private var _moveSprite:Sprite;

		private var _successBit:Bitmap;

		private var _failBit:Bitmap;

		private var _bagList:GhostEquipBagListView;

		private var _proBagList:GhostEquipBagListView;

		private var _equipBagInfo:BagInfo;

		private var _luckyCell:GhostEquipPropCell;
		private var _stoneCell:GhostEquipPropCell;

		private var _equipCell:GhostEquipCell;

		// private var _lastDoAt:int = 0;

		public function FineGhostView()
		{
			super();
			this.initView();
			this.initEvent();
			this.createAcceptDragSprite();
		}

		private function initEvent():void
		{
			this._bagList.addEventListener(CellEvent.ITEM_CLICK, this.cellClickHandler, false, 0, true);
			this._bagList.addEventListener(CellEvent.DOUBLE_CLICK, this.__cellDoubleClick, false, 0, true);
			this._equipCell.addEventListener(Event.CHANGE, this.itemEquipChangeHandler, false, 0, true);
			this._proBagList.addEventListener(CellEvent.ITEM_CLICK, this.cellClickHandler, false, 0, true);
			this._proBagList.addEventListener(CellEvent.DOUBLE_CLICK, this.__cellDoubleClick, false, 0, true);
			this._luckyCell.addEventListener(Event.CHANGE, this.itemEquipChangeHandler, false, 0, true);
			this._stoneCell.addEventListener(Event.CHANGE, this.itemEquipChangeHandler, false, 0, true);

			PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE, this.propInfoChangeHandler);
			PlayerManager.Instance.Self.Bag.addEventListener(BagEvent.UPDATE, this.bagInfoChangeHandler);

			EquipGhostManager.getInstance().addEventListener("equip_ghost_result", this.onEquipGhostResult);
			EquipGhostManager.getInstance().addEventListener("equip_ghost_ratio", this.onEquipGhostRatio);
			EquipGhostManager.getInstance().addEventListener("equip_ghost_state", this.onEquipGhostState);
			this._ghostBtn.addEventListener("click", this.doHandler);
		}

		private function removeEvent():void
		{
			this._bagList.removeEventListener(CellEvent.ITEM_CLICK, this.cellClickHandler);
			this._bagList.removeEventListener(CellEvent.DOUBLE_CLICK, this.__cellDoubleClick);
			this._equipCell.removeEventListener(Event.CHANGE, this.itemEquipChangeHandler);
			this._proBagList.removeEventListener(CellEvent.ITEM_CLICK, this.cellClickHandler);
			this._proBagList.removeEventListener(CellEvent.DOUBLE_CLICK, this.__cellDoubleClick);
			this._luckyCell.removeEventListener(Event.CHANGE, this.itemEquipChangeHandler);
			this._stoneCell.removeEventListener(Event.CHANGE, this.itemEquipChangeHandler);

			PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.UPDATE, this.propInfoChangeHandler);
			PlayerManager.Instance.Self.Bag.removeEventListener(BagEvent.UPDATE, this.bagInfoChangeHandler);

			this._ghostBtn.removeEventListener("click", this.doHandler);
			EquipGhostManager.getInstance().removeEventListener("equip_ghost_result", this.onEquipGhostResult);
			EquipGhostManager.getInstance().removeEventListener("equip_ghost_ratio", this.onEquipGhostRatio);
			EquipGhostManager.getInstance().removeEventListener("equip_ghost_state", this.onEquipGhostState);
		}

		private function propInfoChangeHandler(param1:BagEvent):void
		{
			var _loc2_:InventoryItemInfo = null;
			var _loc3_:InventoryItemInfo = null;
			var _loc4_:InventoryItemInfo = null;
			var _loc5_:Dictionary = param1.changedSlots;
			for each (_loc3_ in _loc5_)
			{
				_loc2_ = _loc3_;
				if (Boolean(_loc2_) && !PlayerManager.Instance.Self.PropBag.items[_loc2_.Place])
				{
					if (this._luckyCell.info && this._luckyCell.itemInfo.Place == _loc2_.Place)
					{
						this._luckyCell.info = null;
					}
					else if (this._stoneCell.info && this._stoneCell.itemInfo.Place == _loc2_.Place)
					{
						this._stoneCell.info = null;
					}
					// else
					// {
					// this._proBagList.setData(EquipGhostManager.instance.getEquipGhostItemData());
					// }
				}
				else
				{
					if (this._luckyCell.info && this._luckyCell.itemInfo.Place == _loc2_.Place)
					{
						_loc4_ = this._luckyCell.itemInfo;

						if (!PlayerManager.Instance.Self.PropBag.items[_loc4_.Place])
						{
							this._luckyCell.info = null;
						}
						else
						{
							this._luckyCell.setCount(_loc4_.Count);
						}
					}
					else if (this._stoneCell.info && this._stoneCell.itemInfo.Place == _loc2_.Place)
					{
						_loc4_ = this._stoneCell.itemInfo;

						if (!PlayerManager.Instance.Self.PropBag.items[_loc4_.Place])
						{
							this._stoneCell.info = null;
						}
						else
						{
							this._stoneCell.setCount(_loc4_.Count);
						}
					}
				}
			}
		}

		private function bagInfoChangeHandler(param1:BagEvent):void
		{
			var _loc2_:InventoryItemInfo = null;
			var _loc3_:InventoryItemInfo = null;
			var _loc4_:BagInfo = null;
			var _loc5_:Dictionary = param1.changedSlots;
			for each (_loc3_ in _loc5_)
			{
				_loc2_ = _loc3_;
			}
			if (Boolean(_loc2_) && !PlayerManager.Instance.Self.Bag.items[_loc2_.Place])
			{
				if (Boolean(this._equipCell.info) && (this._equipCell.info as InventoryItemInfo).Place == _loc2_.Place)
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
				_loc4_ = EquipGhostManager.instance.getCanEquipGhostData();
				if (_loc4_.items.length != this._equipBagInfo.items.length)
				{
					this._equipBagInfo = _loc4_;
					this._bagList.setData(this._equipBagInfo);
				}
			}
			var _loc6_:InventoryItemInfo = this._equipCell.itemInfo;
			if (Boolean(_loc6_) && _loc6_.isGold)
			{
				this._equipCell.info = null;
				this._equipCell.info = _loc6_;
			}
		}

		protected function __cellDoubleClick(param1:CellEvent):void
		{
			SoundManager.instance.play("008");
			if (PlayerManager.Instance.Self.bagLocked)
			{
				BaglockedManager.Instance.show();
				return;
			}
			var _loc2_:String = "";
			var _loc4_:BagCell = param1.data as BagCell;
			if (param1.target == this._proBagList)
			{
				var _type:String = "";
				var _itemInfo:InventoryItemInfo = _loc4_.info as InventoryItemInfo;
				if (_itemInfo.CategoryID == 11)
				{
					if (_itemInfo.Property1 == "117")
					{
						_type = EquipGhostManager.LUCK_TYPE;
					}
					else if (_itemInfo.Property1 == "118")
					{
						_type = EquipGhostManager.STONE_TYPE;
					}
				}

				if (_type == "")
				{
					return;
				}
				_loc2_ = EquipGhostManager.ITEM_MOVE + _type;
			}
			else
			{
				_loc2_ = EquipGhostManager.EQUIP_MOVE;
			}
			var _loc3_:EquipGhostEvent = new EquipGhostEvent(_loc2_);
			_loc3_.info = _loc4_.info as InventoryItemInfo;
			_loc3_.moveType = 1;
			EquipGhostManager.instance.dispatchEvent(_loc3_);
		}

		private function cellClickHandler(param1:CellEvent):void
		{
			SoundManager.instance.play("008");
			var _loc2_:BagCell = param1.data as BagCell;
			_loc2_.dragStart();
		}

		private function createAcceptDragSprite():void
		{
			this._leftDrapSprite = new GhostEquipLeftDragSprite();
			this._leftDrapSprite.mouseEnabled = false;
			this._leftDrapSprite.mouseChildren = false;
			this._leftDrapSprite.graphics.beginFill(0, 0);
			this._leftDrapSprite.graphics.drawRect(0, 0, 347, 404);
			this._leftDrapSprite.graphics.endFill();
			PositionUtils.setPos(this._leftDrapSprite, "wishBeadMainView.leftDrapSpritePos");
			addChild(this._leftDrapSprite);
			this._rightDrapSprite = new GhostEquipRightDragSprite();
			this._rightDrapSprite.mouseEnabled = false;
			this._rightDrapSprite.mouseChildren = false;
			this._rightDrapSprite.graphics.beginFill(0, 0);
			this._rightDrapSprite.graphics.drawRect(0, 0, 374, 407);
			this._rightDrapSprite.graphics.endFill();
			PositionUtils.setPos(this._rightDrapSprite, "wishBeadMainView.rightDrapSpritePos");
			addChild(this._rightDrapSprite);
		}

		private function itemEquipChangeHandler(param1:Event):void
		{
			this.judgeDoBtnStatus();
		}

		private function judgeDoBtnStatus():void
		{
			if (Boolean(this._equipCell.info) && Boolean(this._stoneCell.info) && this._stoneCell.itemInfo.Count > 0)
			{
				this._ghostBtn.enable = true;
			}
			else
			{
				this._ghostBtn.enable = false;
			}
		}

		private function initView():void
		{
			var _loc1_:int = 0;
			var _loc2_:* = null;
			var _loc3_:Bitmap = ComponentFactory.Instance.creatBitmap("equipGhost.leftBg");
			PositionUtils.setPos(_loc3_, "equipGhost.leftBgPos");
			_loc3_.x = 55;
			_loc3_.y = 43;

			addChild(_loc3_);

			this._rightBgView = new ForgeRightBgView();
			// PositionUtils.setPos(this._rightBgView,"forgeMainView.rightBgViewPos");
			this._rightBgView.x = 414;
			this._rightBgView.y = 55;
			addChild(this._rightBgView);
			this.bagBg = ComponentFactory.Instance.creatComponentByStylename("store.bagBG");
			this.bagBg.x = 418;
			this.bagBg.y = 65;
			addChild(this.bagBg);

			this._bagList = new GhostEquipBagListView(BagInfo.EQUIPBAG, 7, 21);
			// PositionUtils.setPos(this._bagList,"wishBeadMainView.bagListPos");
			this._bagList.x = 430;
			this._bagList.y = 93;
			this.refreshBagList();
			addChild(this._bagList);
			this._proBagList = new GhostEquipBagListView(BagInfo.PROPBAG, 7, 21);
			// PositionUtils.setPos(this._proBagList,"wishBeadMainView.proBagListPos");
			this._proBagList.x = 430;
			this._proBagList.y = 267;
			this._proBagList.setData(EquipGhostManager.instance.getEquipGhostItemData());
			addChild(this._proBagList);

			this._luckyStoneCell = ComponentFactory.Instance.creatCustomObject("equipGhost.LuckySymbolCell");
			this._luckyStoneCell.label = LanguageMgr.GetTranslation("equipGhost.luck");
			addChild(this._luckyStoneCell);
			this._luckyCell = new GhostEquipPropCell(EquipGhostManager.LUCK_TYPE, 0, null, true, new Bitmap(new BitmapData(60, 60, true, 0)), false);
			// PositionUtils.setPos(this._luckyCell,"equipGhost.ghostPos0");
			this._luckyCell.x = 92;
			this._luckyCell.y = 172;
			this._luckyCell.BGVisible = false;
			addChild(this._luckyCell);

			this._ghostStoneCell = ComponentFactory.Instance.creatCustomObject("equipGhost.StrengthenStoneCell");
			this._ghostStoneCell.label = LanguageMgr.GetTranslation("equipGhost.stone");
			addChild(this._ghostStoneCell);
			this._stoneCell = new GhostEquipPropCell(EquipGhostManager.STONE_TYPE, 0, null, true, new Bitmap(new BitmapData(60, 60, true, 0)), false);
			// PositionUtils.setPos(this._stoneCell,"equipGhost.ghostPos2");
			this._stoneCell.x = 304;
			this._stoneCell.y = 172;
			this._stoneCell.BGVisible = false;
			addChild(this._stoneCell);

			this._equipmentCell = ComponentFactory.Instance.creatCustomObject("equipGhost.EquipmentCell");
			this._equipmentCell.label = LanguageMgr.GetTranslation("store.Strength.StrengthenEquipmentCellText");
			addChild(this._equipmentCell);
			this._equipCell = new GhostEquipCell(0, null, true, new Bitmap(new BitmapData(60, 60, true, 0)), false);
			this._equipCell.BGVisible = false;
			// PositionUtils.setPos(this._equipCell, "equipGhost.ghostPos1");
			this._equipCell.x = 200;
			this._equipCell.y = 172;
			this._equipCell.setContentSize(68, 68);
			this._equipCell.PicPos = new Point(-3, -5);
			addChild(this._equipCell);

			this._ghostBtn = ComponentFactory.Instance.creatComponentByStylename("equipGhost.ghostButton");
			addChild(this._ghostBtn);
			this._ghostHelpBtn = HelpFrameUtils.Instance.simpleHelpButton(this, "ddtstore.HelpButton", null, LanguageMgr.GetTranslation("store.StoreIIGhost.say"), "ddtstore.HelpFrame.GhostText", 404, 484);
			PositionUtils.setPos(this._ghostHelpBtn, "equipGhost.helpBtnPos");

			this._ratioTxt = ComponentFactory.Instance.creatComponentByStylename("equipGhost.successRatioTxt");
			this._ratioTxt.htmlText = LanguageMgr.GetTranslation("equipGhost.ratioLowTxt");
			addChild(this._ratioTxt);
			this._continuesBtn = ComponentFactory.Instance.creatComponentByStylename("equipGhost.continuousBtn");
			addChild(this._continuesBtn);
		}

		private function refreshBagList():void
		{
			this._equipBagInfo = EquipGhostManager.instance.getCanEquipGhostData();
			this._bagList.setData(this._equipBagInfo);
		}

		private function doHandler(param1:MouseEvent):void
		{
			param1.stopImmediatePropagation();
			this.equipGhost();
		}

		private function equipGhost():void
		{
			SoundManager.instance.play("008");
			if (PlayerManager.Instance.Self.bagLocked)
			{
				BaglockedManager.Instance.show();
				return;
			}
			// var nowAt:int = getTimer();
			// if(nowAt - this._lastDoAt < INTERVAL)
			// {
			// MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.storeIIStrength.startStrengthClickTimerMsg"));
			// return;
			// }
			// this._lastDoAt = nowAt;
			if (this.checkMaterial())
			{
				EquipGhostManager.getInstance().requestEquipGhost();
			}
		}

		private function checkMaterial():Boolean
		{
			var _loc1_:Boolean = true;
			if (this._equipCell.info == null)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("equipGhost.material1"));
				_loc1_ = false;
			}
			else if (this._stoneCell.info == null)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("equipGhost.material2"));
				_loc1_ = false;
			}
			return _loc1_;
		}

		public function show():void
		{
			this.visible = true;
			// this.updateData();
		}

		override public function set visible(param1:Boolean):void
		{
			super.visible = param1;
			if (param1)
			{
				if (!this._isDispose)
				{
					this.refreshListData();
					PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE, this.propInfoChangeHandler);
					PlayerManager.Instance.Self.Bag.addEventListener(BagEvent.UPDATE, this.bagInfoChangeHandler);
				}
			}
			else
			{
				this.clearCellInfo();
				PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.UPDATE, this.propInfoChangeHandler);
				PlayerManager.Instance.Self.Bag.removeEventListener(BagEvent.UPDATE, this.bagInfoChangeHandler);
			}
		}

		public function clearCellInfo():void
		{
			if (Boolean(this._equipCell))
			{
				this._equipCell.clearInfo();
			}
			if (Boolean(this._luckyCell))
			{
				this._luckyCell.clearInfo();
			}
			if (Boolean(this._stoneCell))
			{
				this._stoneCell.clearInfo();
			}
		}

		public function refreshListData():void
		{
			if (Boolean(this._bagList))
			{
				this.refreshBagList();
			}
			if (Boolean(this._proBagList))
			{
				this._proBagList.setData(EquipGhostManager.instance.getEquipGhostItemData());
			}
		}

		public function dispose():void
		{
			TweenMax.killTweensOf(this._moveSprite);
			SoundManager.instance.resumeMusic();
			SoundManager.instance.stop("063");
			SoundManager.instance.stop("064");
			this.removeEvent();
			EquipGhostManager.getInstance().clearEquip();
			EquipGhostManager.getInstance().chooseStoneMaterial(null);
			EquipGhostManager.getInstance().chooseLuckyMaterial(null);

			ObjectUtils.disposeAllChildren(this);
			this._bagList = null;
			this._proBagList = null;
			this._leftDrapSprite = null;
			this._rightDrapSprite = null;
			this._luckyCell = null;
			this._stoneCell = null;
			this._equipCell = null;
			this._equipBagInfo = null;

			this._rightBgView = null;
			this.bagBg = null;
			this._luckyStoneCell = null;
			this._ghostStoneCell = null;
			this._ghostBtn = null;
			this._ghostHelpBtn = null;
			this._equipmentCell = null;
			this._ratioTxt = null;
			if (Boolean(parent))
			{
				parent.removeChild(this);
			}
			this._isDispose = true;
		}

		private function onEquipGhostResult(param1:CEvent):void
		{
			var _loc2_:Boolean = Boolean(param1.data);
			if (!_loc2_)
			{
				this.showResultEffect(false);
			}
			else
			{
				this.showResultEffect();
			}
		}

		private function showResultEffect(param1:Boolean = true):void
		{
			this._ghostBtn.enable = true;
			if (!this._moveSprite)
			{
				this._moveSprite = new Sprite();
				this._moveSprite.mouseEnabled = false;
				this._moveSprite.mouseChildren = false;
				addChild(this._moveSprite);
			}
			if (param1)
			{
				this._successBit = this._successBit || ComponentFactory.Instance.creatBitmap("store.StoreIISuccessBitAsset");
				this._successBit.visible = true;
				if (Boolean(this._failBit))
				{
					this._failBit.visible = false;
				}
				this._moveSprite.addChild(this._successBit);
				SoundManager.instance.pauseMusic();
				SoundManager.instance.play("063", false, false);
			}
			else
			{
				this._failBit = this._failBit || ComponentFactory.Instance.creatBitmap("store.StoreIIFailBitAsset");
				this._failBit.visible = true;
				if (Boolean(this._successBit))
				{
					this._successBit.visible = false;
				}
				this._moveSprite.addChild(this._failBit);
				SoundManager.instance.pauseMusic();
				SoundManager.instance.play("064", false, false);
			}
			TweenMax.killTweensOf(this._moveSprite);
			this._moveSprite.y = 170;
			this._moveSprite.alpha = 1;
			TweenMax.to(this._moveSprite, 0.4, {
						"delay": 1.4,
						"y": 54,
						"alpha": 0,
						"onComplete": this.continueGhost,
						"onCompleteParams": [param1]
					});
		}

		private function continueGhost(param1:Boolean):void
		{
			SoundManager.instance.resumeMusic();
			SoundManager.instance.stop("063");
			SoundManager.instance.stop("064");
			var _loc2_:Boolean = this._stoneCell.info != null;
			if (!param1 && this._continuesBtn.selected && _loc2_)
			{
				EquipGhostManager.getInstance().requestEquipGhost();
			}
		}

		private function onEquipGhostRatio(param1:CEvent):void
		{
			var _loc2_:Number = MathUtils.getValueInRange(Number(param1.data), 1, 99);
			if (_loc2_ < 5)
			{
				this._ratioTxt.htmlText = LanguageMgr.GetTranslation("equipGhost.ratioLowTxt");
			}
			else
			{
				this._ratioTxt.htmlText = LanguageMgr.GetTranslation("equipGhost.ratioTxt", _loc2_);
			}
		}

		private function onEquipGhostState(param1:CEvent):void
		{
			var _loc2_:Boolean = param1.data as Boolean;
			if (Boolean(this._ghostBtn))
			{
				this._ghostBtn.enable = _loc2_;
			}
		}
	}
}
