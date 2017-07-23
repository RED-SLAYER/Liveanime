--Rank-Up Gravity
--fixed by MLD
function c511004425.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c511004425.tgcon)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(c511004425.tgval)
	c:RegisterEffect(e2)
	--banishu
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(c511004425.rmop)
	c:RegisterEffect(e3)
	--SDestroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ADJUST)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c511004425.descon)
	e4:SetOperation(c511004425.desop)
	c:RegisterEffect(e4)
	--activate
	if not c511004425.globalcheck then
		c511004425.globalcheck=true
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetOperation(c511004425.rumcheck)
		Duel.RegisterEffect(e1,0)
	end
end
function c511004425.rumcheck(e,tp,eg,ev,ep,re,r,rp)
	if not re then return end
	local rc=re:GetHandler()
	if rc:IsSetCard(0x95) and rc:IsType(TYPE_SPELL) then
		local ec=eg:GetFirst()
		while ec do
			ec:RegisterFlagEffect(511004425,RESET_EVENT+0x1fe0000,0,0)
			ec=eg:GetNext()
		end
	end
end
function c511004425.filter(c)
	return c:IsType(TYPE_XYZ) and c:GetFlagEffect(511004425)~=0
end
function c511004425.tgcon(e,tp,eg,ev,ep,re,r,rp)
	return Duel.IsExistingMatchingCard(c511004425.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c511004425.tgval(e,c)
	return not c511004425.filter(c)
end
function c511004425.rmfilter(c)
	return c:GetAttackedCount()==0 and c:IsAbleToRemove()
end
function c511004425.rmop(e,tp,eg,ev,ep,re,r,rp)
	if Duel.GetTurnPlayer()==tp then return end
	local g=Duel.GetMatchingGroup(c511004425.rmfilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_CARD,0,511004425)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c511004425.descon(e,tp,eg,ev,ep,re,r,rp)
	return not c511004425.tgcon(e,tp,eg,ev,ep,re,r,rp)
end
function c511004425.desop(e,tp,eg,ev,ep,re,r,rp)
	if Duel.Destroy(e:GetHandler(),REASON_EFFECT)>0 and Duel.GetCurrentPhase()>=PHASE_BATTLE_START 
		and Duel.GetCurrentPhase()<=PHASE_BATTLE then
		Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
	end
end
