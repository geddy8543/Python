select
    dim_policies.bright_policy_id,
    dim_policies.term,
    concat(
        dim_policies.bright_policy_id, '_', dim_policies.term
    ) as mart_accounting_agg_key,
    dim_policies.effective_date::date,
    dim_policies.expiration_date::date,
    dim_policies.final_term_date::date,
    dim_policies.property_id,
    dim_policies.product_id,
    dim_policies.coverage_id,
    dim_policies.frozen_rating_id,
    dim_policies.full_policy_number,
    dim_policies.payment_schedule,
    dim_policies.payment_type,
    round(coalesce(a.earned_surplus, 0), 2) as accounting_ledger_earned_surplus,
    round(coalesce(a.premium_charge_off, 0), 2) as accounting_ledger_premium_charge_off,
    round(coalesce(a.fee_revenue, 0), 2) as accounting_ledger_fee_revenue,
    round(coalesce(a.inspection_fees, 0), 2) as accounting_ledger_inspection_fees,
    round(
        coalesce(a.program_administrator_fee_revenue, 0), 2
    ) as accounting_ledger_program_administrator_fee_revenue,
    round(
        coalesce(a.direct_premiums_written, 0), 2
    ) as accounting_ledger_direct_premiums_written,
    round(
        coalesce(a.change_in_unearned_premium_reserve, 0), 2
    ) as accounting_ledger_change_in_unearned_premium_reserve,
    round(coalesce(a.state_tax_revenue, 0), 2) as accounting_ledger_state_tax_revenue,
    round(
        coalesce(a.state_tax_charge_off, 0), 2
    ) as accounting_ledger_state_tax_charge_off,
    round(coalesce(a.figa_fee_revenue, 0), 2) as accounting_ledger_figa_fee_revenue,
    round(
        coalesce(a.figa_fee_charge_off, 0), 2
    ) as accounting_ledger_figa_fee_charge_off,
    round(coalesce(a.refunds_payable, 0), 2) as accounting_ledger_refunds_payable,
    round(coalesce(a.empa_fee_payable, 0), 2) as accounting_ledger_empa_fee_payable,
    round(
        coalesce(a.unearned_premium_reserve, 0), 2
    ) as accounting_ledger_unearned_premium_reserve,
    round(
        coalesce(a.premiums_received_in_advanced, 0), 2
    ) as accounting_ledger_premiums_received_in_advanced,
    round(coalesce(a.unearned_surplus, 0), 2) as accounting_ledger_unearned_surplus,
    round(
        coalesce(a.state_tax_1_payable, 0), 2
    ) as accounting_ledger_state_tax_1_payable,
    round(
        coalesce(a.state_tax_2_payable, 0), 2
    ) as accounting_ledger_state_tax_2_payable,
    round(
        coalesce(a.state_tax_3_payable, 0), 2
    ) as accounting_ledger_state_tax_3_payable,
    round(
        coalesce(a.premium_tax_deduction_payable, 0), 2
    ) as accounting_ledger_premium_tax_deduction_payable,
    round(
        coalesce(a.fire_marshal_tax_deduction_payable, 0), 2
    ) as accounting_ledger_fire_marshal_tax_deduction_payable,
    round(coalesce(a.premium_receivable, 0), 2) as accounting_ledger_premium_receivable,
    round(
        coalesce(a.deferred_installments, 0), 2
    ) as accounting_ledger_deferred_installments,
    round(coalesce(a.cash, 0), 2) as accounting_ledger_cash,
    round(coalesce(a.unapplied_cash, 0), 2) as accounting_ledger_unapplied_cash,
    round(
        coalesce(a.state_tax_receivable, 0), 2
    ) as accounting_ledger_state_tax_receivable,
    round(
        coalesce(a.figa_fee_receivable, 0), 2
    ) as accounting_ledger_figa_fee_receivable,
    round(coalesce(a.suspense_account, 0), 2) as accounting_ledger_suspense_account,
    round(
        coalesce(a.state_tax_1_receivable, 0), 2
    ) as accounting_ledger_state_tax_1_receivable,
    round(
        coalesce(a.state_tax_2_receivable, 0), 2
    ) as accounting_ledger_state_tax_2_receivable,
    round(
        coalesce(a.state_tax_3_receivable, 0), 2
    ) as accounting_ledger_state_tax_3_receivable,
    round(
        coalesce(a.state_tax_1_charge_off, 0), 2
    ) as accounting_ledger_state_tax_1_charge_off,
    round(
        coalesce(a.state_tax_2_charge_off, 0), 2
    ) as accounting_ledger_state_tax_2_charge_off,
    round(
        coalesce(a.state_tax_3_charge_off, 0), 2
    ) as accounting_ledger_state_tax_3_charge_off,
    round(coalesce(a.unassigned_surplus, 0), 2) as accounting_ledger_unassigned_surplus,
    round(
        coalesce(b.total_accounting_premium_dollar_amount, 0), 2
    ) as billing_total_accounting_premium_dollar_amount,
    round(
        coalesce(b.total_amount_dollar_amount, 0), 2
    ) as billing_total_amount_dollar_amount,
    round(
        coalesce(b.upcoming_amount_dollar_amount, 0), 2
    ) as billing_upcoming_amount_dollar_amount,
    round(
        coalesce(b.approved_amount_dollar_amount, 0), 2
    ) as billing_approved_amount_dollar_amount,
    round(
        coalesce(b.upcoming_accounting_premium_dollar_amount, 0), 2
    ) as billing_upcoming_accounting_premium_dollar_amount,
    round(
        coalesce(b.approved_accounting_premium_dollar_amount, 0), 2
    ) as billing_approved_accounting_premium_dollar_amount,
    round(
        coalesce(b.total_empa_fee_dollar_amount, 0), 2
    ) as billing_total_empa_fee_dollar_amount,
    round(
        coalesce(b.upcoming_empa_fee_dollar_amount, 0), 2
    ) as billing_upcoming_empa_fee_dollar_amount,
    round(
        coalesce(b.approved_empa_fee_dollar_amount, 0), 2
    ) as billing_approved_empa_fee_dollar_amount,
    round(
        coalesce(b.total_figa_fee_dollar_amount, 0), 2
    ) as billing_total_figa_fee_dollar_amount,
    round(
        coalesce(b.upcoming_figa_fee_dollar_amount, 0), 2
    ) as billing_upcoming_figa_fee_dollar_amount,
    round(
        coalesce(b.approved_figa_fee_dollar_amount, 0), 2
    ) as billing_approved_figa_fee_dollar_amount,
    round(
        coalesce(b.total_inspection_fee_dollar_amount, 0), 2
    ) as billing_total_inspection_fee_dollar_amount,
    round(
        coalesce(b.upcoming_inspection_fee_dollar_amount, 0), 2
    ) as billing_upcoming_inspection_fee_dollar_amount,
    round(
        coalesce(b.approved_inspection_fee_dollar_amount, 0), 2
    ) as billing_approved_inspection_fee_dollar_amount,
    round(
        coalesce(b.total_installment_fee_dollar_amount, 0), 2
    ) as billing_total_installment_fee_dollar_amount,
    round(coalesce(b.upcoming_installment, 0), 2) as billing_upcoming_installment,
    round(
        coalesce(b.approved_installment_fee_dollar_amount, 0), 2
    ) as billing_approved_installment_fee_dollar_amount,
    round(
        coalesce(b.total_program_administrator_fee_dollar_amount, 0), 2
    ) as billing_total_program_administrator_fee_dollar_amount,
    round(
        coalesce(b.upcoming_program_administrator_fee_dollar_amount, 0), 2
    ) as billing_upcoming_program_administrator_fee_dollar_amount,
    round(
        coalesce(b.approved_program_administrator_fee_dollar_amount, 0), 2
    ) as billing_approved_program_administrator_fee_dollar_amount,
    round(
        coalesce(b.total_refunds_payable_dollar_amount, 0), 2
    ) as billing_total_refunds_payable_dollar_amount,
    round(coalesce(b.upcoming_refunds, 0), 2) as billing_upcoming_refunds,
    round(
        coalesce(b.approved_refunds_payable_dollar_amount, 0), 2
    ) as billing_approved_refunds_payable_dollar_amount,
    round(
        coalesce(b.total_state_tax_dollar_amount, 0), 2
    ) as billing_total_state_tax_dollar_amount,
    round(
        coalesce(b.upcoming_state_tax_dollar_amount, 0), 2
    ) as billing_upcoming_state_tax_dollar_amount,
    round(
        coalesce(b.approved_state_tax_dollar_amount, 0), 2
    ) as billing_approved_state_tax_dollar_amount,
    round(
        coalesce(b.total_state_tax_1_dollar_amount, 0), 2
    ) as billing_total_state_tax_1_dollar_amount,
    round(
        coalesce(b.upcoming_state_tax_1_dollar_amount, 0), 2
    ) as billing_upcoming_state_tax_1_dollar_amount,
    round(
        coalesce(b.approved_state_tax_1_dollar_amount, 0), 2
    ) as billing_approved_state_tax_1_dollar_amount,
    round(
        coalesce(b.total_state_tax_2_dollar_amount, 0), 2
    ) as billing_total_state_tax_2_dollar_amount,
    round(
        coalesce(b.upcoming_state_tax_2_dollar_amount, 0), 2
    ) as billing_upcoming_state_tax_2_dollar_amount,
    round(
        coalesce(b.approved_state_tax_2_dollar_amount, 0), 2
    ) as billing_approved_state_tax_2_dollar_amount,
    round(
        coalesce(b.total_state_tax_3_dollar_amount, 0), 2
    ) as billing_total_state_tax_3_dollar_amount,
    round(
        coalesce(b.upcoming_state_tax_3_dollar_amount, 0), 2
    ) as billing_upcoming_state_tax_3_dollar_amount,
    round(
        coalesce(b.approved_state_tax_3_dollar_amount, 0), 2
    ) as billing_approved_state_tax_3_dollar_amount,
    round(
        coalesce(b.total_surplus_dollar_amount, 0), 2
    ) as billing_total_surplus_dollar_amount,
    round(
        coalesce(b.upcoming_surplus_dollar_amount, 0), 2
    ) as billing_upcoming_surplus_dollar_amount,
    round(
        coalesce(b.approved_surplus_dollar_amount, 0), 2
    ) as billing_approved_surplus_dollar_amount,
    round(
        coalesce(pt.total_written_premium_amount, 0), 2
    ) as policy_transactions_total_written_premium_amount,
    round(
        coalesce(pt.hurricane_written_premium_amount, 0), 2
    ) as policy_transactions_hurricane_written_premium_amount,
    round(
        coalesce(pt.fire_written_premium_amount, 0), 2
    ) as policy_transactions_fire_written_premium_amount,
    round(
        coalesce(pt.flood_written_premium_amount, 0), 2
    ) as policy_transactions_flood_written_premium_amount,
    round(
        coalesce(pt.earthquake_written_premium_amount, 0), 2
    ) as policy_transactions_earthquake_written_premium_amount,
    round(
        coalesce(pt.wild_fire_written_premium_amount, 0), 2
    ) as policy_transactions_wild_fire_written_premium_amount,
    round(
        coalesce(pt.winter_storm_written_premium_amount, 0), 2
    ) as policy_transactions_winter_storm_written_premium_amount,
    round(
        coalesce(pt.severe_convective_storm_written_premium_amount, 0), 2
    ) as policy_transactions_severe_convective_storm_written_premium_amount,
    round(
        coalesce(pt.all_other_perils_written_premium_amount, 0), 2
    ) as policy_transactions_all_other_perils_written_premium_amount,
    round(
        coalesce(pt.additional_surplus_and_fees_written_premium_amount, 0), 2
    ) as policy_transactions_additional_surplus_and_fees_written_premium_amount,
    round(
        coalesce(pt.surplus_written_premium_amount, 0), 2
    ) as policy_transactions_surplus_written_premium_amount,
    round(
        coalesce(pt.surcharge_written_premium_amount, 0), 2
    ) as policy_transactions_surcharge_written_premium_amount,
    round(
        coalesce(pt.state_tax_written_premium_amount, 0), 2
    ) as policy_transactions_state_tax_written_premium_amount,
    round(
        coalesce(pt.state_tax_1_written_premium_amount, 0), 2
    ) as policy_transactions_state_tax_1_written_premium_amount,
    round(
        coalesce(pt.state_tax_2_written_premium_amount, 0), 2
    ) as policy_transactions_state_tax_2_written_premium_amount,
    round(
        coalesce(pt.state_tax_3_written_premium_amount, 0), 2
    ) as policy_transactions_state_tax_3_written_premium_amount,
    round(
        coalesce(pt.premium_tax_deduction_written_premium_amount, 0), 2
    ) as policy_transactions_premium_tax_deduction_written_premium_amount,
    round(
        coalesce(pt.fire_marshal_tax_deduction_written_premium_amount, 0), 2
    ) as policy_transactions_fire_marshal_tax_deduction_written_premium_amount,
    round(
        coalesce(pt.mga_fee_written_premium_amount, 0), 2
    ) as policy_transactions_mga_fee_written_premium_amount,
    round(
        coalesce(pt.installment_fee_written_premium_amount, 0), 2
    ) as policy_transactions_installment_fee_written_premium_amount,
    round(
        coalesce(pt.inspection_fee_written_premium_amount, 0), 2
    ) as policy_transactions_inspection_fee_written_premium_amount,
    round(
        coalesce(pt.empt_fee_written_premium_amount, 0), 2
    ) as policy_transactions_empt_fee_written_premium_amount,
    round(
        coalesce(pt.figa_recoupment_written_premium_amount, 0), 2
    ) as policy_transactions_figa_recoupment_written_premium_amount,
    round(
        coalesce(pt.total_earned_premium_amount, 0), 2
    ) as policy_transactions_total_earned_premium_amount,
    round(
        coalesce(pt.hurricane_earned_premium_amount, 0), 2
    ) as policy_transactions_hurricane_earned_premium_amount,
    round(
        coalesce(pt.fire_earned_premium_amount, 0), 2
    ) as policy_transactions_fire_earned_premium_amount,
    round(
        coalesce(pt.flood_earned_premium_amount, 0), 2
    ) as policy_transactions_flood_earned_premium_amount,
    round(
        coalesce(pt.earthquake_earned_premium_amount, 0), 2
    ) as policy_transactions_earthquake_earned_premium_amount,
    round(
        coalesce(pt.wild_fire_earned_premium_amount, 0), 2
    ) as policy_transactions_wild_fire_earned_premium_amount,
    round(
        coalesce(pt.winter_storm_earned_premium_amount, 0), 2
    ) as policy_transactions_winter_storm_earned_premium_amount,
    round(
        coalesce(pt.severe_convective_storm_earned_premium_amount, 0), 2
    ) as policy_transactions_severe_convective_storm_earned_premium_amount,
    round(
        coalesce(pt.all_other_perils_earned_premium_amount, 0), 2
    ) as policy_transactions_all_other_perils_earned_premium_amount,
    round(
        coalesce(pt.additional_surplus_and_fees_earned_premium_amount, 0), 2
    ) as policy_transactions_additional_surplus_and_fees_earned_premium_amount,
    round(
        coalesce(pt.surplus_earned_premium_amount, 0), 2
    ) as policy_transactions_surplus_earned_premium_amount,
    round(
        coalesce(pt.surcharge_earned_premium_amount, 0), 2
    ) as policy_transactions_surcharge_earned_premium_amount,
    round(
        coalesce(pt.state_tax_earned_premium_amount, 0), 2
    ) as policy_transactions_state_tax_earned_premium_amount,
    round(
        coalesce(pt.state_tax_1_earned_premium_amount, 0), 2
    ) as policy_transactions_state_tax_1_earned_premium_amount,
    round(
        coalesce(pt.state_tax_2_earned_premium_amount, 0), 2
    ) as policy_transactions_state_tax_2_earned_premium_amount,
    round(
        coalesce(pt.state_tax_3_earned_premium_amount, 0), 2
    ) as policy_transactions_state_tax_3_earned_premium_amount,
    round(
        coalesce(pt.premium_tax_deduction_earned_premium_amount, 0), 2
    ) as policy_transactions_premium_tax_deduction_earned_premium_amount,
    round(
        coalesce(pt.fire_marshal_tax_deduction_earned_premium_amount, 0), 2
    ) as policy_transactions_fire_marshal_tax_deduction_earned_premium_amount,
    round(
        coalesce(pt.mga_fee_earned_premium_amount, 0), 2
    ) as policy_transactions_mga_fee_earned_premium_amount,
    round(
        coalesce(pt.figa_recoupment_earned_premium_amount, 0), 2
    ) as policy_transactions_figa_recoupment_earned_premium_amount
from {{ ref("dim_policies_gold") }} dim_policies
left join
    {{ ref("vw_fact_accounting_ledger_transactions_agg_policy_id_policy_term_gold") }}
    as a
    on dim_policies.bright_policy_id = a.bright_policy_id
    and dim_policies.term = a.policy_term
left join
    {{
        ref(
            "vw_fact_billing_scheduled_transactions_agg_policy_id_policy_term_gold",
        )
    }} as b
    on dim_policies.bright_policy_id = b.bright_policy_id
    and dim_policies.term = b.policy_term
left join
    {{ ref("vw_fact_policy_transactions_agg_policy_id_policy_term_gold") }} as pt
    on dim_policies.bright_policy_id = pt.bright_policy_id
    and dim_policies.term = pt.policy_term