with
    bronze_billing as (
        select
            bst.bright_policy_id,
            bst.term,
            sum(
                (
                    case
                        when bst.payment_type = 'refund'
                        then - bst.amount_cents
                        else bst.amount_cents
                    end
                )
                / 100.00
            ) as bronze_rejected_total_amount_sum,
            sum(
                (
                    case
                        when bst.payment_type = 'refund'
                        then - bst.accounting_premium_cents
                        else bst.accounting_premium_cents
                    end
                )
                / 100.00
            ) as bronze_rejected_premium_sum,
            sum(
                case
                    when bst.status = 'upcoming' and bst.payment_type = 'refund'
                    then bst.accounting_premium_cents * 0.01
                    else 0
                end
            ) as bronze_refund_accounting_premium,
            sum(
                case
                    when bst.status = 'upcoming' and bst.payment_type = 'refund'
                    then
                        (
                            bst.figa_fee_cents
                            + bst.state_tax_cents
                            + bst.state_tax_1_cents
                            + bst.state_tax_2_cents
                            + bst.state_tax_3_cents
                        )
                        * 0.01
                    else 0
                end
            ) as bronze_refund_all_state_tax_amounts,
            sum(
                case
                    when bst.status = 'upcoming' and er.requested_by = 'underwriting'
                    then
                        case when bst.payment_type = 'refund' then -0.01 else 0.01 end
                        * bst.accounting_premium_cents
                    else 0
                end
            ) as bronze_uw_endorsement_premium_amount
        from {{ ref("fact_billing_scheduled_transactions_gold") }} as bst
        left join
            {{ ref("dotcom_endorsement_requests_bronze") }} as er
            on bst.endorsement_request_id = er.id
        where 1 = 1 and bst.deleted_datetime is null and bst.status = 'rejected'
        group by 1, 2
    ),
    gold_billing as (
        select
            bst.bright_policy_id,
            bst.term as policy_term,
            concat(
                bst.bright_policy_id, '_', bst.term
            ) as fact_billing_transactions_agg_key,
            sum(bst.amount_dollar_amount) as total_amount_dollar_amount,
            sum(
                case
                    when bst.status = 'upcoming' then bst.amount_dollar_amount else 0
                end
            ) as upcoming_amount_dollar_amount,
            sum(
                case
                    when bst.status = 'approved' then bst.amount_dollar_amount else 0
                end
            ) as approved_amount_dollar_amount,
            sum(
                bst.accounting_premium_dollar_amount
            ) as total_accounting_premium_dollar_amount,
            sum(
                case
                    when bst.status = 'upcoming'
                    then bst.accounting_premium_dollar_amount
                    else 0
                end
            ) as upcoming_accounting_premium_dollar_amount,
            sum(
                case
                    when bst.status = 'approved'
                    then bst.accounting_premium_dollar_amount
                    else 0
                end
            ) as approved_accounting_premium_dollar_amount,
            sum(bst.empa_fee_dollar_amount) as total_empa_fee_dollar_amount,
            sum(
                case
                    when bst.status = 'upcoming' then bst.empa_fee_dollar_amount else 0
                end
            ) as upcoming_empa_fee_dollar_amount,
            sum(
                case
                    when bst.status = 'approved' then bst.empa_fee_dollar_amount else 0
                end
            ) as approved_empa_fee_dollar_amount,
            sum(bst.figa_fee_dollar_amount) as total_figa_fee_dollar_amount,
            sum(
                case
                    when bst.status = 'upcoming' then bst.figa_fee_dollar_amount else 0
                end
            ) as upcoming_figa_fee_dollar_amount,
            sum(
                case
                    when bst.status = 'approved' then bst.figa_fee_dollar_amount else 0
                end
            ) as approved_figa_fee_dollar_amount,
            sum(bst.inspection_fee_dollar_amount) as total_inspection_fee_dollar_amount,
            sum(
                case
                    when bst.status = 'upcoming'
                    then bst.inspection_fee_dollar_amount
                    else 0
                end
            ) as upcoming_inspection_fee_dollar_amount,
            sum(
                case
                    when bst.status = 'approved'
                    then bst.inspection_fee_dollar_amount
                    else 0
                end
            ) as approved_inspection_fee_dollar_amount,
            sum(
                bst.installment_fee_dollar_amount
            ) as total_installment_fee_dollar_amount,
            sum(
                case
                    when bst.status = 'upcoming'
                    then bst.installment_fee_dollar_amount
                    else 0
                end
            ) as upcoming_installment,
            sum(
                case
                    when bst.status = 'approved'
                    then bst.installment_fee_dollar_amount
                    else 0
                end
            ) as approved_installment_fee_dollar_amount,
            sum(
                bst.program_administrator_fee_dollar_amount
            ) as total_program_administrator_fee_dollar_amount,
            sum(
                case
                    when bst.status = 'upcoming'
                    then bst.program_administrator_fee_dollar_amount
                    else 0
                end
            ) as upcoming_program_administrator_fee_dollar_amount,
            sum(
                case
                    when bst.status = 'approved'
                    then bst.program_administrator_fee_dollar_amount
                    else 0
                end
            ) as approved_program_administrator_fee_dollar_amount,
            sum(
                bst.refunds_payable_dollar_amount
            ) as total_refunds_payable_dollar_amount,
            sum(
                case
                    when bst.status = 'upcoming'
                    then bst.refunds_payable_dollar_amount
                    else 0
                end
            ) as upcoming_refunds,
            sum(
                case
                    when bst.status = 'approved'
                    then bst.refunds_payable_dollar_amount
                    else 0
                end
            ) as approved_refunds_payable_dollar_amount,
            sum(bst.state_tax_dollar_amount) as total_state_tax_dollar_amount,
            sum(
                case
                    when bst.status = 'upcoming' then bst.state_tax_dollar_amount else 0
                end
            ) as upcoming_state_tax_dollar_amount,
            sum(
                case
                    when bst.status = 'approved' then bst.state_tax_dollar_amount else 0
                end
            ) as approved_state_tax_dollar_amount,
            sum(state_tax_1_dollar_amount) as total_state_tax_1_dollar_amount,
            sum(
                case
                    when bst.status = 'upcoming'
                    then bst.state_tax_1_dollar_amount
                    else 0
                end
            ) as upcoming_state_tax_1_dollar_amount,
            sum(
                case
                    when bst.status = 'approved'
                    then bst.state_tax_1_dollar_amount
                    else 0
                end
            ) as approved_state_tax_1_dollar_amount,
            sum(bst.state_tax_2_dollar_amount) as total_state_tax_2_dollar_amount,
            sum(
                case
                    when bst.status = 'upcoming'
                    then bst.state_tax_2_dollar_amount
                    else 0
                end
            ) as upcoming_state_tax_2_dollar_amount,
            sum(
                case
                    when bst.status = 'approved'
                    then bst.state_tax_2_dollar_amount
                    else 0
                end
            ) as approved_state_tax_2_dollar_amount,
            sum(bst.state_tax_3_dollar_amount) as total_state_tax_3_dollar_amount,
            sum(
                case
                    when bst.status = 'upcoming'
                    then bst.state_tax_3_dollar_amount
                    else 0
                end
            ) as upcoming_state_tax_3_dollar_amount,
            sum(
                case
                    when bst.status = 'approved'
                    then bst.state_tax_3_dollar_amount
                    else 0
                end
            ) as approved_state_tax_3_dollar_amount,
            sum(bst.surplus_dollar_amount) as total_surplus_dollar_amount,
            sum(
                case
                    when bst.status = 'upcoming' then bst.surplus_dollar_amount else 0
                end
            ) as upcoming_surplus_dollar_amount,
            sum(
                case
                    when bst.status = 'approved' then bst.surplus_dollar_amount else 0
                end
            ) as approved_surplus_dollar_amount,
            sum(
                case
                    when bst.status = 'rejected' then bst.amount_dollar_amount else 0
                end
            ) as reporting_rejected_total_amount_sum,
            sum(
                case
                    when bst.status = 'rejected'
                    then bst.accounting_premium_dollar_amount
                    else 0
                end
            ) as reporting_rejected_premium_sum,
            sum(
                case
                    when bst.status = 'upcoming' and bst.payment_type = 'refund'
                    then bst.accounting_premium_dollar_amount
                    else 0
                end
            ) as reporting_refund_accounting_premium,
            sum(
                case
                    when bst.status = 'upcoming' and bst.payment_type = 'refund'
                    then
                        (
                            bst.figa_fee_dollar_amount
                            + bst.state_tax_dollar_amount
                            + bst.state_tax_1_dollar_amount
                            + bst.state_tax_2_dollar_amount
                            + bst.state_tax_3_dollar_amount
                        )
                    else 0
                end
            ) as reporting_refund_all_state_tax_amounts,
            sum(
                case
                    when
                        bst.status = 'upcoming'
                        and bst.payment_type = 'refund'
                        and er.requested_by = 'underwriting'
                    then bst.accounting_premium_dollar_amount
                    else 0
                end
            ) as reporting_uw_endorsement_premium_amount
        from {{ ref("fact_billing_scheduled_transactions_gold") }} as bst
        left join
            {{ ref("dotcom_endorsement_requests_bronze") }} as er
            on bst.endorsement_request_id = er.id
        where 1 = 1
        group by 1, 2
    )
select
    dpol.bright_policy_id,
    dpol.term as policy_term,
    coalesce(gb.total_amount_dollar_amount, 0) as total_amount_dollar_amount,
    coalesce(gb.upcoming_amount_dollar_amount, 0) as upcoming_amount_dollar_amount,
    coalesce(gb.approved_amount_dollar_amount, 0) as approved_amount_dollar_amount,
    coalesce(
        gb.total_accounting_premium_dollar_amount, 0
    ) as total_accounting_premium_dollar_amount,
    coalesce(
        gb.upcoming_accounting_premium_dollar_amount, 0
    ) as upcoming_accounting_premium_dollar_amount,
    coalesce(
        gb.approved_accounting_premium_dollar_amount, 0
    ) as approved_accounting_premium_dollar_amount,
    coalesce(gb.total_empa_fee_dollar_amount, 0) as total_empa_fee_dollar_amount,
    coalesce(gb.upcoming_empa_fee_dollar_amount, 0) as upcoming_empa_fee_dollar_amount,
    coalesce(gb.approved_empa_fee_dollar_amount, 0) as approved_empa_fee_dollar_amount,
    coalesce(gb.total_figa_fee_dollar_amount, 0) as total_figa_fee_dollar_amount,
    coalesce(gb.upcoming_figa_fee_dollar_amount, 0) as upcoming_figa_fee_dollar_amount,
    coalesce(gb.approved_figa_fee_dollar_amount, 0) as approved_figa_fee_dollar_amount,
    coalesce(
        gb.total_inspection_fee_dollar_amount, 0
    ) as total_inspection_fee_dollar_amount,
    coalesce(
        gb.upcoming_inspection_fee_dollar_amount, 0
    ) as upcoming_inspection_fee_dollar_amount,
    coalesce(
        gb.approved_inspection_fee_dollar_amount, 0
    ) as approved_inspection_fee_dollar_amount,
    coalesce(
        gb.total_installment_fee_dollar_amount, 0
    ) as total_installment_fee_dollar_amount,
    coalesce(gb.upcoming_installment, 0) as upcoming_installment,
    coalesce(
        gb.approved_installment_fee_dollar_amount, 0
    ) as approved_installment_fee_dollar_amount,
    coalesce(
        gb.total_program_administrator_fee_dollar_amount, 0
    ) as total_program_administrator_fee_dollar_amount,
    coalesce(
        gb.upcoming_program_administrator_fee_dollar_amount, 0
    ) as upcoming_program_administrator_fee_dollar_amount,
    coalesce(
        gb.approved_program_administrator_fee_dollar_amount, 0
    ) as approved_program_administrator_fee_dollar_amount,
    coalesce(
        gb.total_refunds_payable_dollar_amount, 0
    ) as total_refunds_payable_dollar_amount,
    coalesce(gb.upcoming_refunds, 0) as upcoming_refunds,
    coalesce(
        gb.approved_refunds_payable_dollar_amount, 0
    ) as approved_refunds_payable_dollar_amount,
    coalesce(gb.total_state_tax_dollar_amount, 0) as total_state_tax_dollar_amount,
    coalesce(
        gb.upcoming_state_tax_dollar_amount, 0
    ) as upcoming_state_tax_dollar_amount,
    coalesce(
        gb.approved_state_tax_dollar_amount, 0
    ) as approved_state_tax_dollar_amount,
    coalesce(gb.total_state_tax_1_dollar_amount, 0) as total_state_tax_1_dollar_amount,
    coalesce(
        gb.upcoming_state_tax_1_dollar_amount, 0
    ) as upcoming_state_tax_1_dollar_amount,
    coalesce(
        gb.approved_state_tax_1_dollar_amount, 0
    ) as approved_state_tax_1_dollar_amount,
    coalesce(gb.total_state_tax_2_dollar_amount, 0) as total_state_tax_2_dollar_amount,
    coalesce(
        gb.upcoming_state_tax_2_dollar_amount, 0
    ) as upcoming_state_tax_2_dollar_amount,
    coalesce(
        gb.approved_state_tax_2_dollar_amount, 0
    ) as approved_state_tax_2_dollar_amount,
    coalesce(gb.total_state_tax_3_dollar_amount, 0) as total_state_tax_3_dollar_amount,
    coalesce(
        gb.upcoming_state_tax_3_dollar_amount, 0
    ) as upcoming_state_tax_3_dollar_amount,
    coalesce(
        gb.approved_state_tax_3_dollar_amount, 0
    ) as approved_state_tax_3_dollar_amount,
    coalesce(gb.total_surplus_dollar_amount, 0) as total_surplus_dollar_amount,
    coalesce(gb.upcoming_surplus_dollar_amount, 0) as upcoming_surplus_dollar_amount,
    coalesce(gb.approved_surplus_dollar_amount, 0) as approved_surplus_dollar_amount,
    coalesce(
        gb.reporting_rejected_total_amount_sum, 0
    ) as reporting_rejected_total_amount_sum,
    coalesce(gb.reporting_rejected_premium_sum, 0) as reporting_rejected_premium_sum,
    coalesce(
        gb.reporting_refund_accounting_premium, 0
    ) as reporting_refund_accounting_premium,
    coalesce(
        gb.reporting_refund_all_state_tax_amounts, 0
    ) as reporting_refund_all_state_tax_amounts,
    coalesce(
        gb.reporting_uw_endorsement_premium_amount, 0
    ) as reporting_uw_endorsement_premium_amount,
    coalesce(
        bb.bronze_rejected_total_amount_sum, 0
    ) as bronze_rejected_total_amount_sum,
    coalesce(bb.bronze_rejected_premium_sum, 0) as bronze_rejected_premium_sum,
    coalesce(
        bb.bronze_refund_accounting_premium, 0
    ) as bronze_refund_accounting_premium,
    coalesce(
        bb.bronze_refund_all_state_tax_amounts, 0
    ) as bronze_refund_all_state_tax_amounts,
    coalesce(
        bb.bronze_uw_endorsement_premium_amount, 0
    ) as bronze_uw_endorsement_premium_amount,
    'https://app.kin.com/kintranet/properties/'
    || dpol.property_id
    || '/billing' as pas_billing_link
from {{ ref("dim_policies_gold") }} as dpol
left join
    gold_billing as gb
    on gb.bright_policy_id = dpol.bright_policy_id
    and gb.policy_term = dpol.term
left join
    bronze_billing as bb
    on bb.bright_policy_id = dpol.bright_policy_id
    and bb.term = dpol.term
